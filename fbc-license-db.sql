/*
 Navicat MySQL Data Transfer

 Source Server         : 165
 Source Server Type    : MySQL
 Source Server Version : 50732
 Source Host           : 192.168.50.165:3306
 Source Schema         : software_guard

 Target Server Type    : MySQL
 Target Server Version : 50732
 File Encoding         : 65001

 Date: 30/01/2021 11:40:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
create database `software_guard`; SET character_set_client = utf8; use software_guard;
-- ----------------------------
-- Table structure for software_info
-- ----------------------------
DROP TABLE IF EXISTS `software_info`;
CREATE TABLE `software_info`  (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `client_user` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '用户对应的软件序列号',
  `client_sn` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '该用户已经注册了的机器系统编号，目前就使用dmidecode -t 1的输出内容',
  `status` varchar(32) NULL DEFAULT 0 COMMENT '客户端运行状态：未登录，在线，离线，维护中',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `modify_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info`  (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'uuid',
  `username` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '用户名称',
  `validate_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期限',
  `quota` int(10) NULL DEFAULT NULL COMMENT '该用户的客户端容量',
  `count` int(10) NULL DEFAULT NULL COMMENT '该用户的客户端数量',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `modify_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `status_info`;
CREATE TABLE `user_info`  (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'uuid',
  `status_text` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '状态名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

INSERT INTO status_info VALUES('online')
INSERT INTO status_info VALUES('offline')
INSERT INTO status_info VALUES('maintaining')
INSERT INTO status_info VALUES('notlogin')

SET FOREIGN_KEY_CHECKS = 1;
