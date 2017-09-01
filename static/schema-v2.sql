DROP TABLE IF EXISTS "transactions_status"; CREATE TABLE "transactions_status" (
"hash" bytea  NOT NULL DEFAULT '',
"time" int NOT NULL DEFAULT '0',
"type" int NOT NULL DEFAULT '0',
"ecosystem" int NOT NULL DEFAULT '1',
"wallet_id" bigint NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0',
"error" varchar(255) NOT NULL DEFAULT ''
);
ALTER TABLE ONLY "transactions_status" ADD CONSTRAINT transactions_status_pkey PRIMARY KEY (hash);

DROP TABLE IF EXISTS "confirmations"; CREATE TABLE "confirmations" (
"block_id" bigint  NOT NULL DEFAULT '0',
"good" int  NOT NULL DEFAULT '0',
"bad" int  NOT NULL DEFAULT '0',
"time" int  NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "confirmations" ADD CONSTRAINT confirmations_pkey PRIMARY KEY (block_id);

DROP TABLE IF EXISTS "block_chain"; CREATE TABLE "block_chain" (
"id" int NOT NULL DEFAULT '0',
"hash" bytea  NOT NULL DEFAULT '',
"data" bytea NOT NULL DEFAULT '',
"state_id" int  NOT NULL DEFAULT '0',
"wallet_id" bigint  NOT NULL DEFAULT '0',
"time" int NOT NULL DEFAULT '0',
"tx" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "block_chain" ADD CONSTRAINT block_chain_pkey PRIMARY KEY (id);

DROP TABLE IF EXISTS "log_transactions"; CREATE TABLE "log_transactions" (
"hash" bytea  NOT NULL DEFAULT '',
"time" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "log_transactions" ADD CONSTRAINT log_transactions_pkey PRIMARY KEY (hash);

DROP TABLE IF EXISTS "main_lock"; CREATE TABLE "main_lock" (
"lock_time" int  NOT NULL DEFAULT '0',
"script_name" varchar(100) NOT NULL DEFAULT '',
"info" text NOT NULL DEFAULT '',
"uniq" smallint NOT NULL DEFAULT '0'
);
CREATE UNIQUE INDEX main_lock_uniq ON "main_lock" USING btree (uniq);

DROP SEQUENCE IF EXISTS migration_history_id_seq CASCADE;
CREATE SEQUENCE migration_history_id_seq START WITH 1;
DROP TABLE IF EXISTS "migration_history"; CREATE TABLE "migration_history" (
"id" int NOT NULL  default nextval('migration_history_id_seq'),
"version" int NOT NULL DEFAULT '0',
"date_applied" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE migration_history_id_seq owned by migration_history.id;
ALTER TABLE ONLY "migration_history" ADD CONSTRAINT migration_history_pkey PRIMARY KEY (id);

DROP TABLE IF EXISTS "queue_tx"; CREATE TABLE "queue_tx" (
"hash" bytea  NOT NULL DEFAULT '',
"data" bytea NOT NULL DEFAULT '',
"from_gate" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "queue_tx" ADD CONSTRAINT queue_tx_pkey PRIMARY KEY (hash);

DROP TABLE IF EXISTS "config"; CREATE TABLE "config" (
"my_block_id" int NOT NULL DEFAULT '0',
"dlt_wallet_id" bigint NOT NULL DEFAULT '0',
"state_id" int NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"bad_blocks" text NOT NULL DEFAULT '',
"auto_reload" int NOT NULL DEFAULT '0',
"first_load_blockchain_url" varchar(255)  NOT NULL DEFAULT '',
"first_load_blockchain"  varchar(255)  NOT NULL DEFAULT '',
"current_load_blockchain"  varchar(255)  NOT NULL DEFAULT ''
);

DROP SEQUENCE IF EXISTS rollback_rb_id_seq CASCADE;
CREATE SEQUENCE rollback_rb_id_seq START WITH 1;
DROP TABLE IF EXISTS "rollback"; CREATE TABLE "rollback" (
"rb_id" bigint NOT NULL  default nextval('rollback_rb_id_seq'),
"block_id" bigint NOT NULL DEFAULT '0',
"data" text NOT NULL DEFAULT ''
);
ALTER SEQUENCE rollback_rb_id_seq owned by rollback.rb_id;
ALTER TABLE ONLY "rollback" ADD CONSTRAINT rollback_pkey PRIMARY KEY (rb_id);

DROP SEQUENCE IF EXISTS system_states_id_seq CASCADE;
CREATE SEQUENCE system_states_id_seq START WITH 1;
DROP TABLE IF EXISTS "system_states"; CREATE TABLE "system_states" (
"id" bigint NOT NULL default nextval('system_states_id_seq'),
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE system_states_id_seq owned by system_states.id;
ALTER TABLE ONLY "system_states" ADD CONSTRAINT system_states_pkey PRIMARY KEY (id);

DROP TABLE IF EXISTS "system_parameters";
CREATE TABLE "system_parameters" (
"name" varchar(255)  NOT NULL DEFAULT '',
"value" text NOT NULL DEFAULT '',
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint  NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "system_parameters" ADD CONSTRAINT system_parameters_pkey PRIMARY KEY ("name");

INSERT INTO system_parameters ("name", "value", "conditions") VALUES 
('default_ecosystem_page', 'P(class, Default Ecosystem Page)', 'ContractAccess("@0UpdSysParam")'),    
('default_ecosystem_menu', 'MenuItem(main, Default Ecosystem Menu)', 'ContractAccess("@0UpdSysParam")'),
('default_ecosystem_contract', '', 'ContractAccess("@0UpdSysParam")'),
('gap_between_blocks', '3', 'ContractAccess("@0UpdSysParam")'),
('new_version_url', 'upd.apla.io', 'ContractAccess("@0UpdSysParam")'),
('full_nodes', '', 'ContractAccess("@0UpdFullNodes")'),
('count_of_nodes', '101', 'ContractAccess("@0UpdSysParam")'),
('op_price', '', 'ContractAccess("@0UpdSysParam")'),
('blockchain_url', '', 'ContractAccess("@0UpdSysParam")'),
('max_block_size', '67108864', 'ContractAccess("@0UpdSysParam")'),
('max_tx_size', '33554432', 'ContractAccess("@0UpdSysParam")'),
('max_tx_count', '1000', 'ContractAccess("@0UpdSysParam")'),
('max_columns', '50', 'ContractAccess("@0UpdSysParam")'),
('max_block_user_tx', '100', 'ContractAccess("@0UpdSysParam")'),
('max_fuel_tx', '1000', 'ContractAccess("@0UpdSysParam")'),
('max_fuel_block', '100000', 'ContractAccess("@0UpdSysParam")'),
('upd_full_nodes_period', '3600', 'ContractAccess("@0UpdSysParam")'),
('last_upd_full_nodes', '23672372', 'ContractAccess("@0UpdSysParam")'),
('commission_size', '3', 'ContractAccess("@0UpdSysParam")'),
('commission_wallet', '[1,8275283526439353759]', 'ContractAccess("@0UpdSysParam")'),
('sys_currencies', '[1]', 'ContractAccess("@0UpdSysParam")'),
('fuel_rate', '[["1","1000000000000000"]]', 'ContractAccess("@0UpdSysParam")'),
('recovery_address', '[[1,8275283526439353759]]', 'ContractAccess("@0UpdSysParam")');

DROP SEQUENCE IF EXISTS system_contracts_id_seq CASCADE;
CREATE SEQUENCE system_contracts_id_seq START WITH 1;
CREATE TABLE "system_contracts" (
"id" bigint NOT NULL  default nextval('system_contracts_id_seq'),
"value" text  NOT NULL DEFAULT '',
"wallet_id" bigint NOT NULL DEFAULT '0',
"active" character(1) NOT NULL DEFAULT '0',
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE "system_contracts_id_seq" owned by "system_contracts".id;
ALTER TABLE ONLY "system_contracts" ADD CONSTRAINT system_contracts_pkey PRIMARY KEY (id);

INSERT INTO system_contracts ("value", "active", "conditions") VALUES 
('contract UpdSysParam {
    data {
    }
    conditions {
    }
    action {
    }
}', '1','ContractAccess("@0UpdSysContract")'),
('contract UpdSysContract {
    data {
    }
    conditions {
    }
    action {
    }
}', '1','ContractAccess("@0UpdSysContract")'),
('contract UpdFullNodes {
    data {
    }
    conditions {
      Println(`UpdFullNodes condition`)
    }
    action {
      Println(`UpdFullNodes action`)
    }
}', '1','ContractAccess("@0UpdSysContract")');

DROP SEQUENCE IF EXISTS upd_contracts_id_seq CASCADE;
CREATE SEQUENCE upd_contracts_id_seq START WITH 1;
CREATE TABLE "upd_contracts" (
"id" bigint NOT NULL  default nextval('upd_contracts_id_seq'),
"id_contract" bigint  NOT NULL DEFAULT '0',
"value" text  NOT NULL DEFAULT '',
"votes" bigint  NOT NULL DEFAULT '0',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE "upd_contracts_id_seq" owned by "upd_contracts".id;
ALTER TABLE ONLY "upd_contracts" ADD CONSTRAINT upd_contracts_pkey PRIMARY KEY (id);

DROP SEQUENCE IF EXISTS upd_system_parameters_id_seq CASCADE;
CREATE SEQUENCE upd_system_parameters_id_seq START WITH 1;
CREATE TABLE "upd_system_parameters" (
"id" bigint NOT NULL  default nextval('upd_system_parameters_id_seq'),
"name" varchar(255)  NOT NULL DEFAULT '',
"value" text  NOT NULL DEFAULT '',
"votes" bigint  NOT NULL DEFAULT '0',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER SEQUENCE "upd_system_parameters_id_seq" owned by "upd_system_parameters".id;
ALTER TABLE ONLY "upd_system_parameters" ADD CONSTRAINT upd_system_parameters_pkey PRIMARY KEY (id);

CREATE TABLE "system_tables" (
"name" varchar(100)  NOT NULL DEFAULT '',
"permissions" jsonb,
"columns" jsonb,
"conditions" text  NOT NULL DEFAULT '',
"rb_id" bigint NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "system_tables" ADD CONSTRAINT system_tables_pkey PRIMARY KEY (name);

INSERT INTO system_tables ("name", "permissions","columns", "conditions") VALUES ('upd_contracts', 
        '{"insert": "ContractAccess(\"@0UpdSysContract\")", "update": "ContractAccess(\"@0UpdSysContract\")", 
          "new_column": "ContractAccess(\"@0UpdSysContract\")"}',
        '{"id_contract": "ContractAccess(\"@0UpdSysContract\")", "value": "ContractAccess(\"@0UpdSysContract\")", 
          "votes": "ContractAccess(\"@0UpdSysContract\")"}',          
        'ContractAccess(\"@0UpdSysContract\")'),
        ('upd_system_parameters', 
        '{"insert": "ContractAccess(\"@0UpdSysContract\")", "update": "ContractAccess(\"@0UpdSysContract\")", 
          "new_column": "ContractAccess(\"@0UpdSysContract\")"}',
        '{"name": "ContractAccess(\"@0UpdSysContract\")", "value": "ContractAccess(\"@0UpdSysContract\")", 
          "votes": "ContractAccess(\"@0UpdSysContract\")"}',          
        'ContractAccess(\"@0UpdSysContract\")');


DROP TABLE IF EXISTS "info_block"; CREATE TABLE "info_block" (
"hash" bytea  NOT NULL DEFAULT '',
"block_id" int NOT NULL DEFAULT '0',
"state_id" int  NOT NULL DEFAULT '0',
"wallet_id" bigint NOT NULL DEFAULT '0',
"time" int  NOT NULL DEFAULT '0',
"level" smallint  NOT NULL DEFAULT '0',
"current_version" varchar(50) NOT NULL DEFAULT '0.0.1',
"sent" smallint NOT NULL DEFAULT '0'
);

DROP TABLE IF EXISTS "queue_blocks"; CREATE TABLE "queue_blocks" (
"hash" bytea  NOT NULL DEFAULT '',
"full_node_id" int NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0'
);
ALTER TABLE ONLY "queue_blocks" ADD CONSTRAINT queue_blocks_pkey PRIMARY KEY (hash);

DROP TABLE IF EXISTS "transactions"; CREATE TABLE "transactions" (
"hash" bytea  NOT NULL DEFAULT '',
"data" bytea NOT NULL DEFAULT '',
"used" smallint NOT NULL DEFAULT '0',
"high_rate" smallint NOT NULL DEFAULT '0',
"type" smallint NOT NULL DEFAULT '0',
"ecosystem" int NOT NULL DEFAULT '1',
"wallet_id" bigint NOT NULL DEFAULT '0',
"citizen_id" bigint NOT NULL DEFAULT '0',
"counter" smallint NOT NULL DEFAULT '0',
"sent" smallint NOT NULL DEFAULT '0',
"verified" smallint NOT NULL DEFAULT '1'
);
ALTER TABLE ONLY "transactions" ADD CONSTRAINT transactions_pkey PRIMARY KEY (hash);

DROP SEQUENCE IF EXISTS rollback_tx_id_seq CASCADE;
CREATE SEQUENCE rollback_tx_id_seq START WITH 1;
DROP TABLE IF EXISTS "rollback_tx"; CREATE TABLE "rollback_tx" (
"id" bigint NOT NULL  default nextval('rollback_tx_id_seq'),
"block_id" bigint NOT NULL DEFAULT '0',
"tx_hash" bytea  NOT NULL DEFAULT '',
"table_name" varchar(255) NOT NULL DEFAULT '',
"table_id" varchar(255) NOT NULL DEFAULT ''
);
ALTER SEQUENCE rollback_tx_id_seq owned by rollback_tx.id;
ALTER TABLE ONLY "rollback_tx" ADD CONSTRAINT rollback_tx_pkey PRIMARY KEY (id);

DROP TABLE IF EXISTS "install"; CREATE TABLE "install" (
"progress" varchar(10) NOT NULL DEFAULT ''
);


DROP TYPE IF EXISTS "my_node_keys_enum_status" CASCADE;
CREATE TYPE "my_node_keys_enum_status" AS ENUM ('my_pending','approved');
DROP SEQUENCE IF EXISTS my_node_keys_id_seq CASCADE;
CREATE SEQUENCE my_node_keys_id_seq START WITH 1;
DROP TABLE IF EXISTS "my_node_keys"; CREATE TABLE "my_node_keys" (
"id" int NOT NULL  default nextval('my_node_keys_id_seq'),
"add_time" int NOT NULL DEFAULT '0',
"public_key" bytea  NOT NULL DEFAULT '',
"private_key" varchar(3096) NOT NULL DEFAULT '',
"status" my_node_keys_enum_status  NOT NULL DEFAULT 'my_pending',
"my_time" int NOT NULL DEFAULT '0',
"time" bigint NOT NULL DEFAULT '0',
"block_id" int NOT NULL DEFAULT '0',
"rb_id" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE my_node_keys_id_seq owned by my_node_keys.id;
ALTER TABLE ONLY "my_node_keys" ADD CONSTRAINT my_node_keys_pkey PRIMARY KEY (id);

DROP TABLE IF EXISTS "stop_daemons"; CREATE TABLE "stop_daemons" (
"stop_time" int NOT NULL DEFAULT '0'
);

DROP SEQUENCE IF EXISTS full_nodes_id_seq CASCADE;
CREATE SEQUENCE full_nodes_id_seq START WITH 1;
DROP TABLE IF EXISTS "full_nodes"; CREATE TABLE "full_nodes" (
"id" int NOT NULL  default nextval('full_nodes_id_seq'),
"host" varchar(100) NOT NULL DEFAULT '',
"wallet_id" bigint  NOT NULL DEFAULT '0',
"state_id" int NOT NULL DEFAULT '0',
"final_delegate_wallet_id" bigint NOT NULL DEFAULT '0',
"final_delegate_state_id" bigint NOT NULL DEFAULT '0',
"rb_id" int NOT NULL DEFAULT '0'
);
ALTER SEQUENCE full_nodes_id_seq owned by full_nodes.id;
ALTER TABLE ONLY "full_nodes" ADD CONSTRAINT full_nodes_pkey PRIMARY KEY (id);

DROP SEQUENCE IF EXISTS upd_full_nodes_id_seq CASCADE;
CREATE SEQUENCE upd_full_nodes_id_seq START WITH 1;
DROP TABLE IF EXISTS "upd_full_nodes"; CREATE TABLE "upd_full_nodes" (
"id" bigint NOT NULL  default nextval('upd_full_nodes_id_seq'),
"time" int NOT NULL DEFAULT '0',
"rb_id" bigint  REFERENCES rollback(rb_id) NOT NULL DEFAULT '0'
);
ALTER SEQUENCE upd_full_nodes_id_seq owned by upd_full_nodes.id;
ALTER TABLE ONLY "upd_full_nodes" ADD CONSTRAINT upd_full_nodes_pkey PRIMARY KEY (id);