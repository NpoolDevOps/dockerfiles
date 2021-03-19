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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
