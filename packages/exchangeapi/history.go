// Copyright 2016 The go-daylight Authors
// This file is part of the go-daylight library.
//
// The go-daylight library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-daylight library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-daylight library. If not, see <http://www.gnu.org/licenses/>.

package exchangeapi

import (
	"encoding/hex"
	"encoding/json"
	"net/http"
	"time"

	"github.com/EGaaS/go-egaas-mvp/packages/lib"
	"github.com/EGaaS/go-egaas-mvp/packages/utils"
	"github.com/shopspring/decimal"
)

type HistOper struct {
	BlockId string `json:"block_id"`
	Dif     string `json:"dif"`
	Hash    string `json:"txhash"`
	Amount  string `json:"amount"`
	EGS     string `json:"egs"`
	Time    string `json:"time"`
	//	Wallet  string `json:"wallet"`
}

type History struct {
	Error  string     `json:"error"`
	Items  []HistOper `json:"history"`
	Wallet string     `json:"wallet"`
}

func GetHistory(r *http.Request) History {
	return history(r).(History)
}

func history(r *http.Request) interface{} {
	var (
		result History
	)

	wallet := lib.StringToAddress(r.FormValue(`wallet`))
	if wallet == 0 {
		result.Error = `Wallet is invalid`
		return result
	}
	result.Wallet = lib.AddressToString(uint64(wallet))
	count := int(utils.StrToInt64(r.FormValue(`count`)))
	if count == 0 {
		count = 50
	}
	/*	if count > 200 {
		count = 200
	}*/
	list := make([]HistOper, 0)
	current, err := utils.DB.OneRow(`select amount, rb_id from dlt_wallets where wallet_id=?`, wallet).String()
	if err != nil {
		result.Error = err.Error()
		return result
	}
	rb := utils.StrToInt64(current[`rb_id`])
	var (
		prev_block_id string
		prev_list     []map[string]string
		prev_off      int
		prev_hash     string
	)
	if len(current) > 0 && rb != 0 {
		balance, _ := decimal.NewFromString(current[`amount`])
		for len(list) < count && rb > 0 {
			var data map[string]string
			prev, err := utils.DB.OneRow(`select r.*, b.time from rollback as r
			left join block_chain as b on b.id=r.block_id
			where r.rb_id=?`, rb).String()
			if err != nil {
				result.Error = err.Error()
				return result
			}
			if err = json.Unmarshal([]byte(prev[`data`]), &data); err != nil {
				result.Error = err.Error()
				return result
			}
			rb = utils.StrToInt64(data[`rb_id`])
			//			fmt.Println(`DATA`, prev)
			if amount, ok := data[`amount`]; ok {
				var dif decimal.Decimal
				val, _ := decimal.NewFromString(amount)
				if balance.Cmp(val) > 0 {
					dif = balance.Sub(val)
				} else {
					dif = val.Sub(balance)
				}
				sign := `+`
				if balance.Cmp(val) < 0 {
					sign = `-`
				}
				dt := time.Unix(utils.StrToInt64(prev[`time`]), 0)
				if prev_block_id != prev[`block_id`] {
					prev_block_id = prev[`block_id`]
					prev_list, _ = utils.DB.GetAll(`select tx_hash from rollback_tx where block_id=? and table_name='dlt_wallets' and
						    table_id=? order by id desc`,
						-1, prev_block_id, wallet)
					prev_off = 0
				}
				if prev_off < len(prev_list) {
					prev_hash = hex.EncodeToString([]byte(prev_list[prev_off][`tx_hash`]))
					prev_off++
				} else {
					prev_hash = ``
				}
				list = append(list, HistOper{BlockId: prev[`block_id`], Dif: sign + lib.EGSMoney(dif.String()),
					Hash: prev_hash, Amount: balance.String(), EGS: lib.EGSMoney(balance.String()), Time: dt.Format(`02.01.2006 15:04:05`)})
				balance = val

			}
		}
	}
	if rb == 0 {
		first, err := utils.DB.OneRow(`select * from dlt_transactions where recipient_wallet_id=? order by id`, wallet).String()
		if err != nil {
			result.Error = err.Error()
			return result
		}
		if len(first) > 0 {
			if prev_block_id != first[`block_id`] {
				prev_block_id = first[`block_id`]
				prev_list, _ = utils.DB.GetAll(`select tx_hash from rollback_tx where block_id=? and table_name='dlt_wallets' and
						table_id=? order by id desc`,
					-1, prev_block_id, wallet)
				prev_off = 0
			}
			if prev_off < len(prev_list) {
				prev_hash = hex.EncodeToString([]byte(prev_list[prev_off][`tx_hash`]))
				prev_off++
			} else {
				prev_hash = ``
			}
			dt := time.Unix(utils.StrToInt64(first[`time`]), 0)
			list = append(list, HistOper{BlockId: first[`block_id`], Dif: `+` + lib.EGSMoney(first[`amount`]),
				Amount: first[`amount`], Hash: prev_hash,
				EGS: lib.EGSMoney(first[`amount`]), Time: dt.Format(`02.01.2006 15:04:05`)})
		}
	}
	result.Items = list

	return result
}
