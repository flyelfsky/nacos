/*
 * Copyright 1999-2018 Alibaba Group Holding Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info   */
/******************************************/
CREATE TABLE config_info (
  id bigserial primary key,
  data_id varchar(255) NOT NULL,
  group_id varchar(255),
  content text NOT NULL,
  md5 varchar(32),
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint NOT NULL DEFAULT 0,
  src_user text,
  src_ip varchar(20),
  app_name varchar(128),
  tenant_id varchar(128),
  c_desc varchar(256),
  c_use varchar(64),
  effect varchar(64),
  type varchar(64),
  c_schema text,
  constraint uk_configinfo_datagrouptenant UNIQUE (data_id,group_id,tenant_id)
);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_aggr   */
/******************************************/
CREATE TABLE config_info_aggr (
  id bigserial primary key,
  data_id varchar(255) NOT NULL,
  group_id varchar(255) NOT NULL,
  datum_id varchar(255) NOT NULL,
  content text NOT NULL,
  gmt_modified bigint NOT NULL,
  app_name varchar(128),
  tenant_id varchar(128) DEFAULT '',
  constraint uk_configinfoaggr_datagrouptenantdatum UNIQUE (data_id,group_id,tenant_id,datum_id)
);


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_beta   */
/******************************************/
CREATE TABLE config_info_beta (
  id bigserial primary key,
  data_id varchar(255) NOT NULL,
  group_id varchar(128) NOT NULL,
  app_name varchar(128),
  content text NOT NULL,
  beta_ips varchar(1024),
  md5 varchar(32),
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint NOT NULL DEFAULT 0,
  src_user text,
  src_ip varchar(20),
  tenant_id varchar(128) DEFAULT '',
  constraint uk_configinfobeta_datagrouptenant UNIQUE (data_id,group_id,tenant_id)
);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_info_tag   */
/******************************************/
CREATE TABLE config_info_tag (
  id bigserial primary key,
  data_id varchar(255) NOT NULL,
  group_id varchar(128) NOT NULL,
  tenant_id varchar(128) DEFAULT '',
  tag_id varchar(128) NOT NULL,
  app_name varchar(128),
  content text NOT NULL,
  md5 varchar(32),
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint NOT NULL DEFAULT 0,
  src_user text,
  src_ip varchar(20),
  constraint uk_configinfotag_datagrouptenanttag UNIQUE (data_id,group_id,tenant_id,tag_id)
);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = config_tags_relation   */
/******************************************/
CREATE TABLE config_tags_relation (
  id bigint NOT NULL,
  tag_name varchar(128) NOT NULL,
  tag_type varchar(64),
  data_id varchar(255) NOT NULL,
  group_id varchar(128) NOT NULL,
  tenant_id varchar(128) DEFAULT '',
  nid bigserial primary key,
  constraint uk_configtagrelation_configidtag UNIQUE (id,tag_name,tag_type)
);
create index idx_tenant_id on config_tags_relation (tenant_id);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = group_capacity   */
/******************************************/
CREATE TABLE group_capacity (
  id bigserial primary key,
  group_id varchar(128) NOT NULL DEFAULT '',
  quota integer  NOT NULL DEFAULT 0,
  usage integer  NOT NULL DEFAULT 0,
  max_size integer  NOT NULL DEFAULT 0,
  max_aggr_count integer  NOT NULL DEFAULT 0,
  max_aggr_size integer  NOT NULL DEFAULT 0,
  max_history_count integer  NOT NULL DEFAULT 0,
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint DEFAULT 0,
  constraint uk_group_id UNIQUE (group_id)
);
comment on table group_capacity is '集群、各Group容量信息表';
comment on column group_capacity.group_id is 'Group ID，空字符表示整个集群';
comment on column group_capacity.quota is '配额，0表示使用默认值';
comment on column group_capacity.usage is '使用量';
comment on column group_capacity.max_size is '单个配置大小上限，单位为字节，0表示使用默认值';
comment on column group_capacity.max_aggr_count is '聚合子配置最大个数，，0表示使用默认值';
comment on column group_capacity.max_aggr_size is '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值';
comment on column group_capacity.max_history_count is '最大变更历史数量';


/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = his_config_info   */
/******************************************/
CREATE TABLE his_config_info (
  id bigint  NOT NULL,
  nid bigserial  primary key,
  data_id varchar(255) NOT NULL,
  group_id varchar(128) NOT NULL,
  app_name varchar(128),
  content text NOT NULL,
  md5 varchar(32),
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint NOT NULL DEFAULT 0,
  src_user text,
  src_ip varchar(20),
  op_type char(10),
  tenant_id varchar(128) DEFAULT ''
);
comment on table his_config_info is '多租户改造';
create index idx_gmt_create on his_config_info (gmt_create);
create index idx_gmt_modified on his_config_info (gmt_modified);
create index idx_did on his_config_info (data_id);

/******************************************/
/*   数据库全名 = nacos_config   */
/*   表名称 = tenant_capacity   */
/******************************************/
CREATE TABLE tenant_capacity (
  id bigserial  primary key,
  tenant_id varchar(128) NOT NULL DEFAULT '',
  quota integer  NOT NULL DEFAULT 0,
  usage integer  NOT NULL DEFAULT 0,
  max_size integer  NOT NULL DEFAULT 0,
  max_aggr_count integer  NOT NULL DEFAULT 0,
  max_aggr_size integer  NOT NULL DEFAULT 0,
  max_history_count integer  NOT NULL DEFAULT 0,
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint NULL DEFAULT 0,
  constraint uk_tenant_id UNIQUE (tenant_id)
);
comment on table tenant_capacity is '租户容量信息表';
comment on column tenant_capacity.quota is '配额，0表示使用默认值';
comment on column tenant_capacity.usage is '使用量';
comment on column tenant_capacity.max_size is '单个配置大小上限，单位为字节，0表示使用默认值';
comment on column tenant_capacity.max_aggr_count is '聚合子配置最大个数';
comment on column tenant_capacity.max_aggr_size is '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值';
comment on column tenant_capacity.max_history_count is '最大变更历史数量';


CREATE TABLE tenant_info (
  id bigserial primary key,
  kp varchar(128) NOT NULL,
  tenant_id varchar(128) default '',
  tenant_name varchar(128) default '',
  tenant_desc varchar(256),
  create_source varchar(32),
  gmt_create bigint NOT NULL DEFAULT 0,
  gmt_modified bigint NOT NULL DEFAULT 0,
  constraint uk_tenant_info_kptenantid UNIQUE (kp,tenant_id)
);
create index idx_tenant_info_id on tenant_info  (tenant_id);

CREATE TABLE users (
	username varchar(50) NOT NULL PRIMARY KEY,
	password varchar(500) NOT NULL,
	enabled boolean NOT NULL
);

CREATE TABLE roles (
	username varchar(50) NOT NULL,
	role varchar(50) NOT NULL,
	constraint idx_user_role UNIQUE (username, role)
);

CREATE TABLE permissions (
    role varchar(50) NOT NULL,
    resource varchar(255) NOT NULL,
    action varchar(8) NOT NULL,
    constraint uk_role_permission UNIQUE  (role,resource,action)
);

INSERT INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dJN7jexM34MOeYirDdFAZm2kuWj7VEOJhhZkDrxfvUu', TRUE);

INSERT INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');
