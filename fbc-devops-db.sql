/*
 Navicat MySQL Data Transfer

 Source Server         : 165
 Source Server Type    : MySQL
 Source Server Version : 50732
 Source Host           : 127.0.0.1:3306
 Source Schema         : fbc_devops_db

 Target Server Type    : MySQL
 Target Server Version : 50732
 File Encoding         : 65001

 Date: 30/01/2021 11:40:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
create database if not exists `fbc_devops_db`; SET character_set_client = utf8; use fbc_devops_db;
-- ----------------------------
-- Table structure for device_table_config
-- ----------------------------
CREATE TABLE if not exists `device_config` (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `spec` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '本機SPEC',
  `parent_spec` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '父設備SPEC',
  `role` varchar(16) NULL DEFAULT 0 COMMENT '角色: fullnode, miner, worker, storage, fullminer',
  `sub_role` varchar(16) NULL DEFAULT 0 COMMENT '子角色: wallet, accounting, mds, mgr, osd',
  `owner` varchar(32) NULL DEFAULT 0 COMMENT '設備所有者',
  `current_user` varchar(32) NULL DEFAULT 0 COMMENT '設備使用者',
  `manager` varchar(32) NULL DEFAULT 0 COMMENT '設備管理者',
  `nvme_count` int(8) NULL DEFAULT NULL COMMENT '設備的Nvme數量',
  `nvme_desc` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '設備的Nvme描述',
  `gpu_count` int(8) NULL DEFAULT NULL COMMENT '設備的Gpu數量',
  `gpu_desc` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '設備的Gpu描述',
  `memory_size` bigint(64) NULL DEFAULT NULL COMMENT '設備的內存總大小',
  `memory_count` int(8) NULL DEFAULT NULL COMMENT '設備的內存條數',
  `memory_desc` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '設備的內存描述',
  `cpu_count` int(8) NULL DEFAULT NULL COMMENT '設備的Cpu數量',
  `cpu_desc` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '設備的Cpu描述',
  `hdd_count` int(8) NULL DEFAULT NULL COMMENT '設備的Hdd數量',
  `hdd_desc` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '設備的Hdd描述',
  `maintaining` boolean NULL DEFAULT false COMMENT '設備是否處於維護狀態',
  `offline` boolean NULL DEFAULT false COMMENT '設備是否處於離線狀態',
  `updating` boolean NULL DEFAULT false COMMENT '設備是否處於更新設置狀態',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `modify_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for device_role
-- ----------------------------
CREATE TABLE if not exists `device_role`  (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'uuid',
  `role_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '状态名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

REPLACE INTO device_role (id, role_name) VALUES(1, 'fullnode');
REPLACE INTO device_role (id, role_name) VALUES(2, 'miner');
REPLACE INTO device_role (id, role_name) VALUES(3, 'fullminer');
REPLACE INTO device_role (id, role_name) VALUES(4, 'worker');
REPLACE INTO device_role (id, role_name) VALUES(5, 'storage');

SET FOREIGN_KEY_CHECKS = 1;
