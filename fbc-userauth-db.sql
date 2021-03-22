/*
 Navicat MySQL Data Transfer

 Source Server         : 165
 Source Server Type    : MySQL
 Source Server Version : 50732
 Source Host           : 127.0.0.1:3306
 Source Schema         : fbc_userauth_db

 Target Server Type    : MySQL
 Target Server Version : 50732
 File Encoding         : 65001

 Date: 30/01/2021 11:40:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
create database if not exists `fbc_userauth_db`; SET character_set_client = utf8; use fbc_userauth_db;
-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
CREATE TABLE if not exists `auth_user` (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `username` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '用戶名',
  `passwd` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '密碼',
  `salt` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT 'Salt值'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for app_id
-- ----------------------------
CREATE TABLE if not exists `app_id` (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'App UUID',
  `user_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '所屬用戶Id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

REPLACE INTO app_id (id, user_id) VALUES('00000000-0000-0000-0000-000000000000', 'f959f4b2-8880-11eb-b703-0242acac000a');
REPLACE INTO app_id (id, user_id) VALUES('00000001-0001-0001-0001-000000000001', 'f959f4b2-8880-11eb-b703-0242acac000a');


-- ----------------------------
-- Table structure for super_user
-- ----------------------------
CREATE TABLE if not exists `super_user` (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT '用戶ID',
  `visitor` boolean NULL DEFAULT false COMMENT '用戶身份爲訪客',
  PRIMARY KEY (`id`) USING BTREE
} ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

REPLACE INTO super_id (id, visitor) VALUES('f959f4b2-8880-11eb-b703-0242acac000a', false);

SET FOREIGN_KEY_CHECKS = 1;
