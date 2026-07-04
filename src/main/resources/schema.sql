-- ============================================================
-- 4S 店管理系统 — 完整数据库 Schema
-- Database: project1 (MySQL 8.0)
-- ============================================================

-- ============================================================
-- 模块1：系统管理（10 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS sys_dept (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT DEFAULT 0,
    dept_name VARCHAR(50) NOT NULL,
    dept_code VARCHAR(30) NOT NULL,
    sort_order INT DEFAULT 0,
    leader VARCHAR(50) DEFAULT '',
    phone VARCHAR(20) DEFAULT '',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '部门表';

CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    real_name VARCHAR(50) DEFAULT '',
    phone VARCHAR(20) DEFAULT '',
    email VARCHAR(100) DEFAULT '',
    avatar VARCHAR(500) DEFAULT '',
    dept_id BIGINT,
    position VARCHAR(50) DEFAULT '',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    updated_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dept_id (dept_id),
    INDEX idx_username (username)
) COMMENT '系统用户表';

CREATE TABLE IF NOT EXISTS sys_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL,
    role_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255) DEFAULT '',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    updated_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '角色表';

CREATE TABLE IF NOT EXISTS sys_user_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    UNIQUE KEY uk_user_role (user_id, role_id)
) COMMENT '用户角色关联表';

CREATE TABLE IF NOT EXISTS sys_permission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    parent_id BIGINT DEFAULT 0,
    perm_name VARCHAR(50) NOT NULL,
    perm_code VARCHAR(100) DEFAULT '',
    perm_type VARCHAR(10) NOT NULL COMMENT 'MENU/BUTTON',
    path VARCHAR(200) DEFAULT '',
    component VARCHAR(200) DEFAULT '',
    icon VARCHAR(50) DEFAULT '',
    sort_order INT DEFAULT 0,
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '权限菜单表';

CREATE TABLE IF NOT EXISTS sys_role_permission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    UNIQUE KEY uk_role_perm (role_id, permission_id)
) COMMENT '角色权限关联表';

CREATE TABLE IF NOT EXISTS sys_dict_type (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dict_name VARCHAR(50) NOT NULL,
    dict_code VARCHAR(50) NOT NULL UNIQUE,
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '字典类型表';

CREATE TABLE IF NOT EXISTS sys_dict (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dict_type_id BIGINT NOT NULL,
    dict_label VARCHAR(50) NOT NULL,
    dict_value VARCHAR(50) NOT NULL,
    sort_order INT DEFAULT 0,
    css_class VARCHAR(50) DEFAULT '',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dict_type (dict_type_id)
) COMMENT '数据字典表';

CREATE TABLE IF NOT EXISTS sys_config (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    config_name VARCHAR(50) NOT NULL,
    config_key VARCHAR(50) NOT NULL UNIQUE,
    config_value VARCHAR(500) NOT NULL,
    config_type VARCHAR(20) DEFAULT 'STRING',
    remark VARCHAR(200) DEFAULT '',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '系统参数表';

CREATE TABLE IF NOT EXISTS sys_operation_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    username VARCHAR(50) DEFAULT '',
    module VARCHAR(50) DEFAULT '',
    action VARCHAR(50) DEFAULT '',
    method VARCHAR(200) DEFAULT '',
    request_url VARCHAR(500) DEFAULT '',
    request_method VARCHAR(10) DEFAULT '',
    request_params TEXT,
    response_result TEXT,
    ip VARCHAR(50) DEFAULT '',
    duration BIGINT DEFAULT 0,
    status TINYINT DEFAULT 1,
    error_msg TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    INDEX idx_module (module)
) COMMENT '操作日志表';

-- ============================================================
-- 模块2：CRM 客户关系管理（7 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS crm_customer (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_type VARCHAR(20) NOT NULL DEFAULT 'PROSPECT' COMMENT 'PROSPECT/OWNER',
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(5) DEFAULT '',
    phone VARCHAR(20) NOT NULL,
    wechat VARCHAR(50) DEFAULT '',
    id_card VARCHAR(20) DEFAULT '',
    address VARCHAR(200) DEFAULT '',
    source VARCHAR(30) DEFAULT '' COMMENT '客户来源',
    source_channel VARCHAR(50) DEFAULT '',
    intent_vehicle_id BIGINT COMMENT '意向车型ID',
    intent_model VARCHAR(100) DEFAULT '',
    budget DECIMAL(12,2) DEFAULT 0,
    competitor_info VARCHAR(200) DEFAULT '' COMMENT '关注竞品',
    grade VARCHAR(5) DEFAULT 'C' COMMENT 'H/A/B/C/D 意向级别',
    owner_vehicle_id BIGINT COMMENT '已购车辆ID（车主专用）',
    purchase_date DATE COMMENT '购车日期（车主专用）',
    owner_vin VARCHAR(30) DEFAULT '' COMMENT 'VIN码（车主专用）',
    birthday DATE,
    insurance_due_date DATE COMMENT '保险到期日',
    inspection_due_date DATE COMMENT '年检到期日',
    assignee_id BIGINT COMMENT '负责销售顾问',
    remark VARCHAR(500) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_phone (phone),
    INDEX idx_assignee (assignee_id),
    INDEX idx_grade (grade),
    INDEX idx_customer_type (customer_type)
) COMMENT '客户档案表';

CREATE TABLE IF NOT EXISTS crm_follow_up (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    follow_method VARCHAR(20) NOT NULL COMMENT 'PHONE/WECHAT/VISIT/OTHER',
    summary TEXT NOT NULL,
    result VARCHAR(200) DEFAULT '',
    next_follow_time DATETIME,
    follow_by BIGINT NOT NULL,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_id (customer_id),
    INDEX idx_follow_by (follow_by),
    INDEX idx_next_follow (next_follow_time)
) COMMENT '客户跟进记录表';

CREATE TABLE IF NOT EXISTS crm_lead (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) DEFAULT '',
    phone VARCHAR(20) NOT NULL,
    source VARCHAR(30) DEFAULT '' COMMENT '客户来源',
    source_channel VARCHAR(50) DEFAULT '' COMMENT '渠道: 抖音/懂车帝/Walk-in等',
    intent_vehicle_id BIGINT,
    intent_model VARCHAR(100) DEFAULT '',
    budget_range VARCHAR(30) DEFAULT '',
    status VARCHAR(20) DEFAULT 'PUBLIC' COMMENT 'PUBLIC/ASSIGNED/CONVERTED/LOST',
    assignee_id BIGINT,
    assign_time DATETIME,
    claim_days INT DEFAULT 3 COMMENT '规定跟进天数',
    lost_reason VARCHAR(200) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_phone (phone),
    INDEX idx_status (status),
    INDEX idx_assignee (assignee_id),
    INDEX idx_created_at (created_at)
) COMMENT '线索表（公海池）';

CREATE TABLE IF NOT EXISTS crm_lead_assign_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    lead_id BIGINT NOT NULL,
    from_user_id BIGINT,
    to_user_id BIGINT NOT NULL,
    assign_type VARCHAR(20) NOT NULL COMMENT 'MANUAL/AUTO/RETURN',
    remark VARCHAR(200) DEFAULT '',
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_lead_id (lead_id)
) COMMENT '线索分配日志表';

CREATE TABLE IF NOT EXISTS crm_lost_customer (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    lead_id BIGINT,
    lost_reason VARCHAR(50) NOT NULL COMMENT 'PRICE/MODEL_MISMATCH/COMPETITOR/SERVICE/OTHER',
    detail VARCHAR(500) DEFAULT '',
    review_status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED',
    reviewer_id BIGINT,
    review_comment VARCHAR(200) DEFAULT '',
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_id (customer_id)
) COMMENT '战败客户表';

CREATE TABLE IF NOT EXISTS crm_reminder (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    reminder_type VARCHAR(20) NOT NULL COMMENT 'BIRTHDAY/INSURANCE/INSPECTION/FOLLOW_UP',
    remind_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/DONE/DISMISSED',
    assignee_id BIGINT NOT NULL,
    remark VARCHAR(200) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_remind_time (remind_time),
    INDEX idx_assignee (assignee_id),
    INDEX idx_status (status)
) COMMENT '提醒任务表';

-- ============================================================
-- 模块3：整车销售（7 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS sale_opportunity (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    lead_id BIGINT,
    vehicle_model_id BIGINT COMMENT '意向车型ID',
    intent_color VARCHAR(30) DEFAULT '',
    intent_config VARCHAR(200) DEFAULT '',
    payment_method VARCHAR(20) DEFAULT '' COMMENT 'FULL/LOAN',
    status VARCHAR(20) DEFAULT 'FOLLOWING' COMMENT 'FOLLOWING/QUOTED/ORDERED/LOST',
    expected_close_date DATE,
    assignee_id BIGINT,
    remark VARCHAR(500) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer_id (customer_id),
    INDEX idx_assignee (assignee_id),
    INDEX idx_status (status)
) COMMENT '销售机会/意向单表';

CREATE TABLE IF NOT EXISTS sale_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_no VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    opportunity_id BIGINT,
    vehicle_model_id BIGINT COMMENT '车型ID',
    stock_vehicle_id BIGINT COMMENT '配车VIN ID',
    guide_price DECIMAL(12,2) DEFAULT 0 COMMENT '指导价',
    discount DECIMAL(12,2) DEFAULT 0 COMMENT '优惠金额',
    purchase_tax DECIMAL(12,2) DEFAULT 0 COMMENT '购置税',
    insurance_amount DECIMAL(12,2) DEFAULT 0 COMMENT '保险费',
    license_fee DECIMAL(12,2) DEFAULT 0 COMMENT '上牌费',
    accessory_amount DECIMAL(12,2) DEFAULT 0 COMMENT '精品加装费',
    total_price DECIMAL(12,2) DEFAULT 0 COMMENT '包牌总价',
    deposit DECIMAL(12,2) DEFAULT 0 COMMENT '定金',
    payment_method VARCHAR(20) DEFAULT '' COMMENT 'FULL/LOAN',
    status VARCHAR(20) DEFAULT 'PENDING_APPROVAL' COMMENT 'PENDING_APPROVAL/PENDING_DEPOSIT/PENDING_ALLOCATION/PENDING_DELIVERY/COMPLETED/CANCELLED',
    assignee_id BIGINT,
    signing_date DATE COMMENT '签约日期',
    expected_delivery_date DATE COMMENT '预计交车日期',
    remark VARCHAR(500) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_no (order_no),
    INDEX idx_customer_id (customer_id),
    INDEX idx_assignee (assignee_id),
    INDEX idx_status (status)
) COMMENT '销售订单表';

CREATE TABLE IF NOT EXISTS sale_order_approval (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    approval_level VARCHAR(30) NOT NULL COMMENT 'MANAGER/DIRECTOR/REGIONAL',
    approver_id BIGINT NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED',
    comment VARCHAR(200) DEFAULT '',
    approved_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id)
) COMMENT '价格审批表';

CREATE TABLE IF NOT EXISTS sale_derivative (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    biz_type VARCHAR(20) NOT NULL COMMENT 'INSURANCE/FINANCE/TRADE_IN/EXTENDED_WARRANTY',
    provider VARCHAR(100) DEFAULT '' COMMENT '保险公司/银行等',
    product_name VARCHAR(100) DEFAULT '',
    amount DECIMAL(12,2) DEFAULT 0,
    detail TEXT COMMENT 'JSON格式详细内容',
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id)
) COMMENT '衍生业务表';

CREATE TABLE IF NOT EXISTS sale_delivery (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    stock_vehicle_id BIGINT,
    pdi_status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/PASSED/FAILED',
    pdi_checker_id BIGINT,
    pdi_time DATETIME,
    wash_status VARCHAR(20) DEFAULT 'PENDING',
    document_prepared TINYINT DEFAULT 0 COMMENT '资料准备完成',
    ceremony_time DATETIME,
    customer_interview_result VARCHAR(50) DEFAULT '',
    delivery_status VARCHAR(20) DEFAULT 'IN_PROGRESS' COMMENT 'IN_PROGRESS/COMPLETED',
    delivered_at DATETIME,
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id)
) COMMENT '车辆交付PDI表';

CREATE TABLE IF NOT EXISTS sale_contract (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    contract_no VARCHAR(30) NOT NULL UNIQUE,
    order_id BIGINT NOT NULL,
    contract_content TEXT NOT NULL COMMENT '合同HTML内容',
    signed_status VARCHAR(20) DEFAULT 'UNSIGNED' COMMENT 'UNSIGNED/SIGNED',
    signed_at DATETIME,
    file_path VARCHAR(500) DEFAULT '' COMMENT '合同文件路径',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order_id (order_id)
) COMMENT '销售合同表';

-- ============================================================
-- 模块4：库存管理（8 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS stock_vehicle (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vin VARCHAR(30) NOT NULL UNIQUE,
    engine_no VARCHAR(30) DEFAULT '',
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    model_year INT NOT NULL,
    vehicle_type VARCHAR(30) DEFAULT '',
    color VARCHAR(30) DEFAULT '',
    config_detail VARCHAR(200) DEFAULT '',
    production_date DATE,
    guide_price DECIMAL(12,2) DEFAULT 0,
    cost_price DECIMAL(12,2) DEFAULT 0 COMMENT '成本价',
    status VARCHAR(20) NOT NULL DEFAULT 'IN_TRANSIT' COMMENT 'IN_TRANSIT/IN_STOCK/SHOWROOM/RESERVED/PDI/PENDING_DELIVERY/DELIVERED',
    location VARCHAR(50) DEFAULT '' COMMENT '库位',
    inbound_date DATE COMMENT '入库日期',
    outbound_date DATE COMMENT '出库日期',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_vin (vin),
    INDEX idx_status (status),
    INDEX idx_brand_model (brand, model),
    INDEX idx_inbound_date (inbound_date)
) COMMENT '整车库存表';

CREATE TABLE IF NOT EXISTS stock_vehicle_inbound (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    inbound_no VARCHAR(30) NOT NULL UNIQUE,
    stock_vehicle_id BIGINT NOT NULL,
    supplier VARCHAR(100) DEFAULT '' COMMENT '厂家/供应商',
    inbound_date DATE NOT NULL,
    inbound_type VARCHAR(30) DEFAULT 'PURCHASE' COMMENT 'PURCHASE/RETURN/TRANSFER',
    remark VARCHAR(200) DEFAULT '',
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_stock_vehicle (stock_vehicle_id),
    INDEX idx_inbound_date (inbound_date)
) COMMENT '整车入库记录表';

CREATE TABLE IF NOT EXISTS stock_vehicle_outbound (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    outbound_no VARCHAR(30) NOT NULL UNIQUE,
    stock_vehicle_id BIGINT NOT NULL,
    order_id BIGINT COMMENT '关联销售订单',
    outbound_date DATE NOT NULL,
    outbound_type VARCHAR(30) NOT NULL COMMENT 'SALE/TRANSFER/TEST_DRIVE',
    receiver VARCHAR(50) DEFAULT '',
    remark VARCHAR(200) DEFAULT '',
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_stock_vehicle (stock_vehicle_id),
    INDEX idx_outbound_date (outbound_date)
) COMMENT '整车出库记录表';

CREATE TABLE IF NOT EXISTS stock_accessory (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    accessory_code VARCHAR(30) NOT NULL UNIQUE,
    accessory_name VARCHAR(100) NOT NULL,
    category VARCHAR(30) DEFAULT '' COMMENT '脚垫/贴膜/导航/其他',
    unit VARCHAR(10) DEFAULT '套',
    price DECIMAL(10,2) DEFAULT 0,
    quantity INT DEFAULT 0,
    alert_quantity INT DEFAULT 5 COMMENT '库存预警数量',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '精品配件库存表';

CREATE TABLE IF NOT EXISTS stock_accessory_inbound (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    inbound_no VARCHAR(30) NOT NULL UNIQUE,
    accessory_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_price DECIMAL(12,2) DEFAULT 0,
    supplier VARCHAR(100) DEFAULT '',
    inbound_date DATE NOT NULL,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT '配件入库表';

CREATE TABLE IF NOT EXISTS stock_accessory_outbound (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    outbound_no VARCHAR(30) NOT NULL UNIQUE,
    accessory_id BIGINT NOT NULL,
    order_id BIGINT COMMENT '关联销售订单ID',
    work_order_id BIGINT COMMENT '关联维修工单ID',
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_price DECIMAL(12,2) DEFAULT 0,
    outbound_date DATE NOT NULL,
    outbound_type VARCHAR(20) NOT NULL COMMENT 'SALE/REPAIR/OTHER',
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT '配件出库表';

CREATE TABLE IF NOT EXISTS stock_check (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    check_no VARCHAR(30) NOT NULL UNIQUE,
    check_type VARCHAR(20) NOT NULL COMMENT 'VEHICLE/ACCESSORY',
    check_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'IN_PROGRESS' COMMENT 'IN_PROGRESS/COMPLETED',
    profit_loss_summary TEXT COMMENT '盘盈盘亏汇总 JSON',
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '盘点单表';

CREATE TABLE IF NOT EXISTS stock_check_detail (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    check_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL COMMENT '对应 stock_vehicle.id 或 stock_accessory.id',
    item_type VARCHAR(20) NOT NULL COMMENT 'VEHICLE/ACCESSORY',
    book_quantity INT DEFAULT 0 COMMENT '账面数量',
    actual_quantity INT DEFAULT 0 COMMENT '实盘数量',
    diff_quantity INT DEFAULT 0 COMMENT '差异',
    diff_reason VARCHAR(200) DEFAULT '',
    INDEX idx_check_id (check_id)
) COMMENT '盘点明细表';

CREATE TABLE IF NOT EXISTS vehicle_video (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id BIGINT NOT NULL COMMENT '关联 stock_vehicle.id',
    title VARCHAR(100) DEFAULT '' COMMENT '视频标题',
    video_url VARCHAR(500) NOT NULL COMMENT '视频地址(本地路径或外部链接)',
    cover_url VARCHAR(500) DEFAULT '' COMMENT '封面图地址',
    source_type VARCHAR(10) DEFAULT 'LOCAL' COMMENT 'LOCAL/LINK',
    sort_order INT DEFAULT 0 COMMENT '排序',
    created_by BIGINT COMMENT '上传人',
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_vehicle_id (vehicle_id)
) COMMENT '车辆介绍视频表';

-- ============================================================
-- 模块5：售后维修（8 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS svc_appointment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    vehicle_info VARCHAR(100) DEFAULT '' COMMENT '车型+车牌',
    appointment_time DATETIME NOT NULL,
    service_type VARCHAR(30) DEFAULT 'MAINTENANCE' COMMENT 'MAINTENANCE/REPAIR/BODY_WORK/OTHER',
    description VARCHAR(500) DEFAULT '' COMMENT '客户描述问题',
    status VARCHAR(20) DEFAULT 'CONFIRMED' COMMENT 'PENDING/CONFIRMED/ARRIVED/CANCELLED',
    service_advisor_id BIGINT COMMENT '服务顾问',
    remark VARCHAR(200) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_appointment_time (appointment_time),
    INDEX idx_customer_id (customer_id),
    INDEX idx_advisor (service_advisor_id)
) COMMENT '售后预约表';

CREATE TABLE IF NOT EXISTS svc_work_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    wo_no VARCHAR(30) NOT NULL UNIQUE,
    appointment_id BIGINT,
    customer_id BIGINT NOT NULL,
    vehicle_desc VARCHAR(200) DEFAULT '' COMMENT '车型/车牌/VIN',
    mileage INT DEFAULT 0 COMMENT '进厂里程',
    fuel_level VARCHAR(10) DEFAULT '' COMMENT '油量',
    exterior_condition TEXT COMMENT '外观状况记录',
    customer_complaint TEXT NOT NULL COMMENT '客户描述问题',
    technician_finding TEXT COMMENT '技师检查发现',
    service_type VARCHAR(30) DEFAULT 'REPAIR',
    status VARCHAR(20) DEFAULT 'RECEPTION' COMMENT 'RECEPTION/DISPATCHED/IN_PROGRESS/QC/WASH/SETTLEMENT/COMPLETED',
    service_advisor_id BIGINT,
    started_at DATETIME,
    completed_at DATETIME,
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wo_no (wo_no),
    INDEX idx_customer_id (customer_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) COMMENT '维修工单表';

CREATE TABLE IF NOT EXISTS svc_dispatch (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    work_order_id BIGINT NOT NULL,
    technician_id BIGINT NOT NULL COMMENT '技师',
    dispatch_by BIGINT COMMENT '派工人',
    dispatch_time DATETIME,
    start_time DATETIME COMMENT '技师开工时间',
    end_time DATETIME COMMENT '技师完工时间',
    labor_hours DECIMAL(5,2) DEFAULT 0 COMMENT '工时数',
    status VARCHAR(20) DEFAULT 'ASSIGNED' COMMENT 'ASSIGNED/STARTED/COMPLETED',
    remark VARCHAR(200) DEFAULT '',
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wo_id (work_order_id),
    INDEX idx_technician (technician_id)
) COMMENT '派工表';

CREATE TABLE IF NOT EXISTS svc_parts_requisition (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    work_order_id BIGINT NOT NULL,
    accessory_id BIGINT NOT NULL COMMENT '关联配件库存',
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) DEFAULT 0,
    total_price DECIMAL(12,2) DEFAULT 0,
    request_by BIGINT COMMENT '领料人',
    approved_by BIGINT COMMENT '审批人',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/DELIVERED',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wo_id (work_order_id)
) COMMENT '配件领料表';

CREATE TABLE IF NOT EXISTS svc_quality_check (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    work_order_id BIGINT NOT NULL,
    checker_id BIGINT,
    check_result VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/PASSED/FAILED',
    check_items TEXT COMMENT '质检项目JSON',
    issue_found VARCHAR(500) DEFAULT '',
    checked_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wo_id (work_order_id)
) COMMENT '质检表';

CREATE TABLE IF NOT EXISTS svc_settlement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    work_order_id BIGINT NOT NULL UNIQUE,
    labor_fee DECIMAL(12,2) DEFAULT 0 COMMENT '工时费',
    parts_fee DECIMAL(12,2) DEFAULT 0 COMMENT '配件费',
    material_fee DECIMAL(12,2) DEFAULT 0 COMMENT '辅料费',
    outsourced_fee DECIMAL(12,2) DEFAULT 0 COMMENT '外包项目费',
    discount DECIMAL(12,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    payment_method VARCHAR(20) DEFAULT '' COMMENT 'CASH/CARD/TRANSFER/COMBINED',
    payment_status VARCHAR(20) DEFAULT 'UNPAID' COMMENT 'UNPAID/PARTIAL/PAID',
    paid_amount DECIMAL(12,2) DEFAULT 0,
    settled_by BIGINT,
    settled_at DATETIME,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wo_id (work_order_id)
) COMMENT '售后结算表';

CREATE TABLE IF NOT EXISTS svc_follow_up (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    work_order_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    follow_up_time DATETIME COMMENT '回访时间',
    satisfaction_score INT DEFAULT 0 COMMENT '满意度评分 1-5',
    feedback VARCHAR(500) DEFAULT '',
    follow_by BIGINT,
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/DONE/SKIPPED',
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_wo_id (work_order_id),
    INDEX idx_customer_id (customer_id)
) COMMENT '售后回访表';

-- ============================================================
-- 模块6：财务结算（6 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS fin_payment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_no VARCHAR(30) NOT NULL UNIQUE,
    payment_type VARCHAR(30) NOT NULL COMMENT 'SALE_DEPOSIT/SALE_BALANCE/SERVICE/INSURANCE/OTHER',
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL COMMENT 'CASH/BANK_CARD/WECHAT/ALIPAY/TRANSFER',
    voucher_no VARCHAR(50) DEFAULT '' COMMENT '凭证号/流水号',
    order_id BIGINT COMMENT '关联销售订单',
    work_order_id BIGINT COMMENT '关联维修工单',
    customer_id BIGINT,
    payer_name VARCHAR(50) DEFAULT '',
    remark VARCHAR(200) DEFAULT '',
    status VARCHAR(20) DEFAULT 'COMPLETED' COMMENT 'COMPLETED/REFUNDED/PART_REFUND',
    received_by BIGINT COMMENT '收款人',
    paid_at DATETIME,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_payment_type (payment_type),
    INDEX idx_order_id (order_id),
    INDEX idx_paid_at (paid_at)
) COMMENT '收款表';

CREATE TABLE IF NOT EXISTS fin_invoice (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_no VARCHAR(30) NOT NULL UNIQUE,
    invoice_type VARCHAR(20) NOT NULL COMMENT 'SALE/SERVICE/OTHER',
    order_id BIGINT,
    work_order_id BIGINT,
    customer_name VARCHAR(50) DEFAULT '',
    amount DECIMAL(12,2) DEFAULT 0,
    tax_amount DECIMAL(12,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ISSUED' COMMENT 'ISSUED/VOIDED/RED_FLUSH',
    issued_by BIGINT,
    issued_at DATETIME,
    voided_at DATETIME,
    void_reason VARCHAR(200) DEFAULT '',
    file_path VARCHAR(500) DEFAULT '' COMMENT '发票文件路径',
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_invoice_no (invoice_no),
    INDEX idx_order_id (order_id)
) COMMENT '发票表';

CREATE TABLE IF NOT EXISTS fin_refund (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    refund_no VARCHAR(30) NOT NULL UNIQUE,
    payment_id BIGINT NOT NULL COMMENT '原收款记录',
    amount DECIMAL(12,2) NOT NULL,
    reason VARCHAR(200) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/COMPLETED/REJECTED',
    approved_by BIGINT,
    approved_at DATETIME,
    refunded_at DATETIME,
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_payment_id (payment_id)
) COMMENT '退款表';

CREATE TABLE IF NOT EXISTS fin_receivable (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    receivable_no VARCHAR(30) NOT NULL UNIQUE,
    customer_name VARCHAR(50) NOT NULL,
    order_id BIGINT,
    amount DECIMAL(12,2) NOT NULL,
    paid_amount DECIMAL(12,2) DEFAULT 0,
    due_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/PARTIAL/PAID/OVERDUE',
    collection_records TEXT COMMENT '催收记录 JSON',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_due_date (due_date),
    INDEX idx_status (status)
) COMMENT '应收账款表';

CREATE TABLE IF NOT EXISTS fin_daily_settlement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    settle_date DATE NOT NULL,
    settle_by BIGINT COMMENT '收银员',
    cash_amount DECIMAL(12,2) DEFAULT 0,
    card_amount DECIMAL(12,2) DEFAULT 0,
    wechat_amount DECIMAL(12,2) DEFAULT 0,
    alipay_amount DECIMAL(12,2) DEFAULT 0,
    transfer_amount DECIMAL(12,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    bank_amount DECIMAL(12,2) DEFAULT 0 COMMENT '银行流水总额',
    diff_amount DECIMAL(12,2) DEFAULT 0 COMMENT '差异',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/CONFIRMED',
    confirmed_by BIGINT,
    confirmed_at DATETIME,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_date_user (settle_date, settle_by)
) COMMENT '日结表';

CREATE TABLE IF NOT EXISTS fin_profit (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    period_type VARCHAR(10) NOT NULL COMMENT 'MONTH/QUARTER/YEAR',
    period_value VARCHAR(20) NOT NULL COMMENT '2026-05',
    biz_type VARCHAR(20) NOT NULL COMMENT 'SALE/SERVICE/ACCESSORY',
    revenue DECIMAL(14,2) DEFAULT 0 COMMENT '收入',
    cost DECIMAL(14,2) DEFAULT 0 COMMENT '成本',
    gross_profit DECIMAL(14,2) DEFAULT 0 COMMENT '毛利',
    gross_margin DECIMAL(5,2) DEFAULT 0 COMMENT '毛利率',
    expense DECIMAL(14,2) DEFAULT 0 COMMENT '费用',
    net_profit DECIMAL(14,2) DEFAULT 0 COMMENT '净利润',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_period (period_value, biz_type)
) COMMENT '利润核算表';

-- ============================================================
-- 模块7：统计报表（1 张汇总表）
-- ============================================================

CREATE TABLE IF NOT EXISTS rpt_summary (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_date DATE NOT NULL,
    report_type VARCHAR(30) NOT NULL COMMENT 'DAILY_SALES/DAILY_SERVICE/DAILY_FINANCE',
    metric_key VARCHAR(50) NOT NULL COMMENT '指标键',
    metric_value DECIMAL(14,2) DEFAULT 0 COMMENT '指标值',
    metric_json TEXT COMMENT 'JSON补充数据',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_date_type_key (report_date, report_type, metric_key)
) COMMENT '报表汇总表';

-- ============================================================
-- 模块8：市场营销（4 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS mkt_campaign (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    campaign_type VARCHAR(30) DEFAULT '' COMMENT 'AUTO_SHOW/STORE_EVENT/GROUP_BUY/OTHER',
    budget DECIMAL(12,2) DEFAULT 0,
    actual_cost DECIMAL(12,2) DEFAULT 0,
    start_date DATE,
    end_date DATE,
    expected_leads INT DEFAULT 0 COMMENT '预期获客数',
    actual_leads INT DEFAULT 0 COMMENT '实际获客数',
    status VARCHAR(20) DEFAULT 'PLANNING' COMMENT 'PLANNING/IN_PROGRESS/COMPLETED/CANCELLED',
    description TEXT,
    responsible_id BIGINT,
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '市场活动表';

CREATE TABLE IF NOT EXISTS mkt_lead_channel (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    channel_name VARCHAR(50) NOT NULL COMMENT '抖音/懂车帝/快手/百度等',
    channel_code VARCHAR(30) NOT NULL UNIQUE,
    lead_count INT DEFAULT 0 COMMENT '线索总数',
    converted_count INT DEFAULT 0 COMMENT '成交数',
    total_cost DECIMAL(12,2) DEFAULT 0 COMMENT '总费用',
    per_lead_cost DECIMAL(10,2) DEFAULT 0 COMMENT '单线索成本',
    roi DECIMAL(5,2) DEFAULT 0 COMMENT '投资回报率',
    status TINYINT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '新媒体线索渠道表';

CREATE TABLE IF NOT EXISTS mkt_coupon (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    coupon_name VARCHAR(100) NOT NULL,
    coupon_type VARCHAR(30) NOT NULL COMMENT 'MAINTENANCE/LABOR/DISCOUNT/OTHER',
    face_value DECIMAL(10,2) DEFAULT 0 COMMENT '面值',
    threshold_amount DECIMAL(10,2) DEFAULT 0 COMMENT '满减门槛',
    total_quantity INT DEFAULT 0 COMMENT '发行总数',
    issued_quantity INT DEFAULT 0,
    used_quantity INT DEFAULT 0,
    valid_from DATE,
    valid_to DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE' COMMENT 'ACTIVE/PAUSED/EXPIRED',
    is_deleted TINYINT DEFAULT 0,
    created_by BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '优惠券表';

CREATE TABLE IF NOT EXISTS mkt_coupon_issue (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    coupon_id BIGINT NOT NULL,
    coupon_code VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT,
    issued_to VARCHAR(50) DEFAULT '',
    status VARCHAR(20) DEFAULT 'UNUSED' COMMENT 'UNUSED/USED/EXPIRED',
    used_at DATETIME,
    work_order_id BIGINT COMMENT '核销关联工单',
    order_id BIGINT COMMENT '核销关联订单',
    issued_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_coupon_id (coupon_id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_coupon_code (coupon_code)
) COMMENT '卡券发放核销表';

-- ============================================================
-- 初始化种子数据
-- ============================================================

INSERT IGNORE INTO sys_dept (id, parent_id, dept_name, dept_code, sort_order) VALUES
(1, 0, '总经办', 'HEAD_OFFICE', 1),
(2, 0, '销售部', 'SALES', 2),
(3, 0, '售后部', 'AFTERSALES', 3),
(4, 0, '市场部', 'MARKETING', 4),
(5, 0, '财务部', 'FINANCE', 5),
(6, 0, '行政部', 'ADMIN', 6);

INSERT IGNORE INTO sys_role (id, role_name, role_code, description) VALUES
(1, '系统管理员', 'ADMIN', '拥有所有权限'),
(2, '销售经理', 'SALES_MANAGER', '管理销售团队和线索分配'),
(3, '销售顾问', 'SALES_CONSULTANT', '跟进客户和创建订单'),
(4, '售后经理', 'SERVICE_MANAGER', '管理售后团队'),
(5, '服务顾问', 'SERVICE_ADVISOR', '接车和工单管理'),
(6, '技师', 'TECHNICIAN', '维修执行'),
(7, '财务', 'FINANCE', '收款、发票和结算'),
(8, '店长', 'STORE_MANAGER', '查看所有报表和数据');

INSERT IGNORE INTO sys_user (id, username, password, real_name, dept_id, phone) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5Eh', '系统管理员', 1, '13800000000');

INSERT IGNORE INTO sys_user_role (user_id, role_id) VALUES (1, 1);

INSERT IGNORE INTO sys_permission (id, parent_id, perm_name, perm_type, path, icon, sort_order) VALUES
(1, 0, '系统管理', 'MENU', '/system', 'Setting', 1),
(2, 1, '用户管理', 'MENU', '/system/users', 'User', 10),
(3, 1, '角色管理', 'MENU', '/system/roles', 'Avatar', 20),
(4, 1, '权限管理', 'MENU', '/system/permissions', 'Lock', 30),
(5, 1, '部门管理', 'MENU', '/system/depts', 'OfficeBuilding', 40),
(6, 1, '数据字典', 'MENU', '/system/dict', 'Collection', 50),
(7, 1, '系统参数', 'MENU', '/system/config', 'Tools', 60),
(8, 1, '操作日志', 'MENU', '/system/logs', 'Document', 70),
(10, 0, '客户关系', 'MENU', '/crm', 'UserFilled', 2),
(11, 10, '客户档案', 'MENU', '/crm/customers', 'UserFilled', 10),
(12, 10, '跟进记录', 'MENU', '/crm/follow-ups', 'ChatLineSquare', 20),
(13, 10, '线索公海', 'MENU', '/crm/leads', 'Ship', 30),
(14, 10, '战败客户', 'MENU', '/crm/lost', 'Warning', 40),
(15, 10, '提醒任务', 'MENU', '/crm/reminders', 'AlarmClock', 50),
(20, 0, '整车销售', 'MENU', '/sale', 'Sell', 3),
(21, 20, '销售机会', 'MENU', '/sale/opportunities', 'Opportunity', 10),
(22, 20, '订单管理', 'MENU', '/sale/orders', 'Tickets', 20),
(23, 20, '车辆交付', 'MENU', '/sale/deliveries', 'Van', 30),
(24, 20, '合同管理', 'MENU', '/sale/contracts', 'DocumentChecked', 40),
(30, 0, '库存管理', 'MENU', '/stock', 'Box', 4),
(31, 30, '整车库存', 'MENU', '/stock/vehicles', 'Van', 10),
(32, 30, '入库管理', 'MENU', '/stock/inbound', 'Download', 20),
(33, 30, '出库管理', 'MENU', '/stock/outbound', 'Upload', 30),
(34, 30, '配件库存', 'MENU', '/stock/accessories', 'Goods', 40),
(35, 30, '盘点管理', 'MENU', '/stock/checks', 'Check', 50),
(40, 0, '售后维修', 'MENU', '/service', 'Tool', 5),
(41, 40, '预约管理', 'MENU', '/service/appointments', 'Calendar', 10),
(42, 40, '维修工单', 'MENU', '/service/work-orders', 'Notebook', 20),
(43, 40, '结算管理', 'MENU', '/service/settlements', 'Money', 30),
(44, 40, '回访管理', 'MENU', '/service/follow-ups', 'Phone', 40),
(50, 0, '财务结算', 'MENU', '/finance', 'Money', 6),
(51, 50, '收款管理', 'MENU', '/finance/payments', 'CreditCard', 10),
(52, 50, '发票管理', 'MENU', '/finance/invoices', 'Receipt', 20),
(53, 50, '退款管理', 'MENU', '/finance/refunds', 'Money', 30),
(54, 50, '应收账款', 'MENU', '/finance/receivables', 'Wallet', 40),
(55, 50, '日结管理', 'MENU', '/finance/daily-settle', 'DataAnalysis', 50),
(60, 0, '统计报表', 'MENU', '/report', 'DataAnalysis', 7),
(61, 60, '销售漏斗', 'MENU', '/report/sales-funnel', 'PieChart', 10),
(62, 60, '销售业绩', 'MENU', '/report/sales-performance', 'TrendCharts', 20),
(63, 60, '售后业绩', 'MENU', '/report/service-performance', 'TrendCharts', 30),
(64, 60, '库存分析', 'MENU', '/report/inventory', 'Odometer', 40),
(65, 60, '财务报表', 'MENU', '/report/finance', 'TrendCharts', 50),
(70, 0, '市场营销', 'MENU', '/marketing', 'Promotion', 8),
(71, 70, '活动管理', 'MENU', '/marketing/campaigns', 'Flag', 10),
(72, 70, '渠道管理', 'MENU', '/marketing/channels', 'Share', 20),
(73, 70, '卡券管理', 'MENU', '/marketing/coupons', 'Ticket', 30);

INSERT IGNORE INTO sys_dict_type (id, dict_name, dict_code) VALUES
(1, '客户来源', 'customer_source'),
(2, '客户级别', 'customer_grade'),
(3, '付款方式', 'payment_method'),
(4, '车辆类型', 'vehicle_type'),
(5, '订单状态', 'order_status'),
(6, '线索状态', 'lead_status'),
(7, '跟进方式', 'follow_method');

INSERT IGNORE INTO sys_dict (dict_type_id, dict_label, dict_value, sort_order) VALUES
(1, '进店', 'WALK_IN', 1),
(1, '网销', 'ONLINE', 2),
(1, '外拓', 'OUTREACH', 3),
(1, '老客户介绍', 'REFERRAL', 4),
(1, '车展', 'AUTO_SHOW', 5),
(1, '电话', 'PHONE', 6),
(2, 'H级-1周内成交', 'H', 1),
(2, 'A级-1月内成交', 'A', 2),
(2, 'B级-3月内成交', 'B', 3),
(2, 'C级-半年内成交', 'C', 4),
(2, 'D级-无意向', 'D', 5),
(3, '全款', 'FULL', 1),
(3, '分期/贷款', 'LOAN', 2),
(4, '轿车', 'SEDAN', 1),
(4, 'SUV', 'SUV', 2),
(4, 'MPV', 'MPV', 3),
(4, '新能源', 'EV', 4),
(4, '跑车', 'SPORTS', 5),
(7, '电话', 'PHONE', 1),
(7, '微信', 'WECHAT', 2),
(7, '到店', 'VISIT', 3),
(7, '其他', 'OTHER', 4);

-- ============================================================
-- 模块 C：客户端（C端）- 微信小程序/H5（10 张表）
-- ============================================================

CREATE TABLE IF NOT EXISTS customer_vehicle (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL COMMENT '关联 crm_customer.id',
    vin VARCHAR(30) DEFAULT '' COMMENT 'VIN码',
    license_plate VARCHAR(20) DEFAULT '' COMMENT '车牌号',
    brand VARCHAR(50) DEFAULT '',
    model VARCHAR(100) DEFAULT '',
    model_year INT DEFAULT 0,
    mileage INT DEFAULT 0 COMMENT '当前里程',
    engine_no VARCHAR(30) DEFAULT '',
    insurance_company VARCHAR(50) DEFAULT '',
    insurance_due_date DATE,
    inspection_due_date DATE,
    is_default TINYINT DEFAULT 0 COMMENT '默认车辆',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_vin (vin),
    INDEX idx_plate (license_plate)
) COMMENT '客户绑定车辆表';

CREATE TABLE IF NOT EXISTS customer_points (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    total_points INT DEFAULT 0 COMMENT '当前积分',
    total_growth INT DEFAULT 0 COMMENT '成长值',
    member_level VARCHAR(20) DEFAULT 'NORMAL' COMMENT 'NORMAL/SILVER/GOLD/PLATINUM/DIAMOND',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id)
) COMMENT '客户积分表';

CREATE TABLE IF NOT EXISTS customer_points_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    change_type VARCHAR(20) NOT NULL COMMENT 'EARN/CONSUME/EXPIRE',
    points INT NOT NULL COMMENT '变更积分',
    growth INT DEFAULT 0 COMMENT '变更成长值',
    source VARCHAR(50) DEFAULT '' COMMENT '来源: 消费/签到/活动/推荐',
    source_id BIGINT COMMENT '来源ID',
    remark VARCHAR(200) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_created_at (created_at)
) COMMENT '积分变动日志表';

CREATE TABLE IF NOT EXISTS mall_product (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(30) NOT NULL COMMENT 'MAINTENANCE_PACKAGE/ACCESSORY/CHEMICAL/OTHER',
    image_url VARCHAR(500) DEFAULT '',
    original_price DECIMAL(10,2) DEFAULT 0,
    sale_price DECIMAL(10,2) DEFAULT 0,
    stock INT DEFAULT 0,
    sales INT DEFAULT 0 COMMENT '销量',
    description TEXT,
    detail_images TEXT COMMENT '详情图JSON数组',
    status VARCHAR(20) DEFAULT 'ON_SALE' COMMENT 'ON_SALE/OFF_SALE',
    sort_order INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '商城商品表';

CREATE TABLE IF NOT EXISTS mall_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_no VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    pay_amount DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'PENDING_PAY' COMMENT 'PENDING_PAY/PAID/SHIPPED/COMPLETED/CANCELLED',
    pay_method VARCHAR(20) DEFAULT '',
    pay_time DATETIME,
    remark VARCHAR(200) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_order_no (order_no)
) COMMENT '商城订单表';

CREATE TABLE IF NOT EXISTS mall_order_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    product_name VARCHAR(100) DEFAULT '',
    price DECIMAL(10,2) DEFAULT 0,
    quantity INT DEFAULT 1,
    total_price DECIMAL(10,2) DEFAULT 0,
    INDEX idx_order_id (order_id)
) COMMENT '商城订单明细表';

CREATE TABLE IF NOT EXISTS rescue_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    rescue_no VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    vehicle_id BIGINT COMMENT '关联 customer_vehicle.id',
    contact_name VARCHAR(50) DEFAULT '',
    contact_phone VARCHAR(20) NOT NULL,
    latitude DECIMAL(10,7) DEFAULT 0 COMMENT '纬度',
    longitude DECIMAL(10,7) DEFAULT 0 COMMENT '经度',
    address VARCHAR(200) DEFAULT '',
    rescue_type VARCHAR(30) DEFAULT 'ROADSIDE' COMMENT 'ROADSIDE/TOWING/FLAT_TIRE/DEAD_BATTERY/OTHER',
    description VARCHAR(500) DEFAULT '',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/DISPATCHED/ARRIVED/RESCUING/COMPLETED/CANCELLED',
    dispatcher_id BIGINT COMMENT '派单员',
    rescue_company VARCHAR(100) DEFAULT '',
    arrived_at DATETIME,
    completed_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_status (status)
) COMMENT '道路救援工单表';

CREATE TABLE IF NOT EXISTS accident_report (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_no VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    vehicle_id BIGINT,
    accident_time DATETIME,
    accident_location VARCHAR(200) DEFAULT '',
    accident_type VARCHAR(30) DEFAULT '' COMMENT 'COLLISION/SCRATCH/REAR_END/OTHER',
    description TEXT,
    damage_images TEXT COMMENT '损伤照片JSON数组',
    insurance_claimed TINYINT DEFAULT 0 COMMENT '是否已报保险',
    insurance_claim_no VARCHAR(50) DEFAULT '',
    status VARCHAR(20) DEFAULT 'REPORTED' COMMENT 'REPORTED/CONFIRMED/INSPECTING/REPAIRING/COMPLETED',
    work_order_id BIGINT COMMENT '关联维修工单',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_status (status)
) COMMENT '事故报案表';

CREATE TABLE IF NOT EXISTS valuation_request (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    vehicle_id BIGINT,
    brand VARCHAR(50) DEFAULT '',
    model VARCHAR(100) DEFAULT '',
    model_year INT DEFAULT 0,
    mileage INT DEFAULT 0,
    license_plate VARCHAR(20) DEFAULT '',
    purchase_date DATE,
    estimated_price DECIMAL(12,2) DEFAULT 0 COMMENT '系统估值',
    manual_price DECIMAL(12,2) DEFAULT 0 COMMENT '人工评估价',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/EVALUATED/DEAL/CLOSED',
    evaluator_id BIGINT COMMENT '评估师',
    remark VARCHAR(500) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_status (status)
) COMMENT '二手车估价申请表';

CREATE TABLE IF NOT EXISTS customer_advisor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL UNIQUE,
    sales_advisor_id BIGINT COMMENT '专属销售顾问',
    service_advisor_id BIGINT COMMENT '专属服务顾问',
    sales_advisor_qrcode VARCHAR(500) DEFAULT '' COMMENT '企微二维码',
    service_advisor_qrcode VARCHAR(500) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id)
) COMMENT '专属顾问分配表';

-- ============================================================
-- AI 智能客服模块（知识库 + 聊天历史 + 客服工单）
-- ============================================================

CREATE TABLE IF NOT EXISTS kb_faq (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(30) NOT NULL COMMENT 'MAINTENANCE/INSURANCE/PRICE/PROCESS/OTHER',
    question VARCHAR(500) NOT NULL,
    answer TEXT NOT NULL,
    keywords VARCHAR(200) DEFAULT '' COMMENT '关键词,逗号分隔',
    sort_order INT DEFAULT 0,
    status TINYINT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'AI知识库FAQ表';

CREATE TABLE IF NOT EXISTS ai_chat_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL COMMENT '会话ID',
    customer_id BIGINT,
    role VARCHAR(10) NOT NULL COMMENT 'USER/AI/SYSTEM',
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_session (session_id),
    INDEX idx_customer (customer_id),
    INDEX idx_created (created_at)
) COMMENT 'AI聊天历史表';

CREATE TABLE IF NOT EXISTS cs_ticket (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ticket_no VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    customer_name VARCHAR(50) DEFAULT '',
    phone VARCHAR(20) DEFAULT '',
    category VARCHAR(30) DEFAULT '' COMMENT 'CONSULTATION/COMPLAINT/RESCUE/OTHER',
    question TEXT COMMENT '客户问题摘要',
    chat_context TEXT COMMENT 'AI对话上下文JSON',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT 'PENDING/ASSIGNED/PROCESSING/RESOLVED/CLOSED',
    assignee_id BIGINT COMMENT '分配的客服人员',
    resolution TEXT COMMENT '解决方案',
    priority VARCHAR(10) DEFAULT 'NORMAL' COMMENT 'LOW/NORMAL/HIGH/URGENT',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_customer (customer_id),
    INDEX idx_status (status),
    INDEX idx_assignee (assignee_id)
) COMMENT '人工客服工单表';

-- ============================================================
-- AI 知识库种子数据
-- ============================================================

INSERT IGNORE INTO kb_faq (category, question, answer, keywords, sort_order) VALUES
('MAINTENANCE', '首保什么时候做', '新车首保一般为购车后3个月或3000-5000公里（以先到为准），具体以车辆保养手册为准。首保通常免费，包含更换机油、机滤以及全车检查。', '首保,保养,时间,公里,免费', 1),
('MAINTENANCE', '小保养和大保养有什么区别', '小保养一般指更换机油和机油滤芯，费用约500-1500元；大保养在4-6万公里时进行，在机油三滤基础上增加火花塞、变速箱油、刹车油等更换，费用约2000-8000元。', '保养,大小保养,机油,费用', 2),
('MAINTENANCE', '机油怎么选', '选择机油需看粘度等级和品质等级。普通矿物油5000公里更换，半合成油7500公里，全合成油10000公里。涡轮增压车型建议用全合成机油。我们店提供壳牌、嘉实多、美孚等品牌。', '机油,全合成,半合成,粘度', 3),
('MAINTENANCE', '刹车片多久换一次', '前刹车片一般3-5万公里更换，后刹车片5-8万公里更换。具体需根据驾驶习惯和路况而定，建议每次保养时检查刹车片厚度，厚度低于3mm需及时更换。', '刹车片,更换,公里,厚度', 4),
('INSURANCE', '新车保险怎么买', '新车需购买交强险（必买）+ 车损险 + 三者险（建议100万以上）+ 不计免赔。其他如划痕险、涉水险、自燃险按需选择。我们店合作多家保险公司，可帮您比价出单。', '保险,新车,交强险,三者险,车损险', 10),
('INSURANCE', '出险后怎么处理', '1.开启双闪，放置警示牌；2.拍照取证（全景+细节+车牌）；3.拨打保险公司电话报案；4.轻微事故可走快处快赔；5.联系我们店协助定损维修。切记不要私了后逃逸。', '出险,事故,报案,保险,处理', 11),
('INSURANCE', '保险到期前多久续保', '建议保险到期前30-45天续保，可享受最大折扣。过期未续保上路属于违法行为，且脱保超过3个月保费会上浮。我们店提供续保提醒服务。', '续保,保险到期,折扣,脱保', 12),
('PRICE', '买车落地价包含哪些费用', '落地价 = 裸车价 + 购置税（约车价÷11.3）+ 保险费（约5000-8000元）+ 上牌费（约500元）。部分车型可能还有金融服务费、精品加装费等。', '落地价,购置税,保险,上牌费,费用', 20),
('PRICE', '贷款买车和全款哪个划算', '全款购车总支出更低（无利息和手续费）；贷款购车资金压力小，但需支付利息和金融服务费（通常2000-5000元）。目前部分车型有厂家免息政策，可咨询销售顾问了解。', '贷款,全款,利息,金融服务费', 21),
('PROCESS', '提车流程是怎样的', '1.验车（外观/内饰/功能/发动机）；2.交尾款；3.购买保险；4.办理临牌；5.交车仪式；6.领取资料（发票/合格证/说明书/保养手册）。全程约2-3小时。', '提车,流程,验车,临牌,交车', 30),
('PROCESS', '车辆年检怎么办理', '新车6年内免上线检测，每2年领取检验标志；6-10年每2年上线检测一次；10-15年每年一次；15年以上每半年一次。我们店可代办年检服务。', '年检,免检,上线,代办', 31),
('PROCESS', '预约保养怎么操作', '可通过微信小程序选择保养类型（基础保养/常规检修）、到店日期和时间段，系统会自动排班。预约客户可享受优先接待服务和工时费9折优惠。', '预约,保养,小程序,排班,优惠', 32),
('OTHER', '你们店的营业时间', '销售展厅：每日9:00-18:00（节假日不休）；售后服务中心：周一至周六8:30-17:30（周日可预约紧急维修）；24小时救援电话：400-xxx-xxxx。', '营业时间,展厅,售后,救援电话', 40),
('OTHER', '有没有代步车服务', '重大维修（超过48小时）可申请免费代步车，需提前预约。小修和保养提供免费茶歇和WiFi等候区，也可安排免费接送服务。', '代步车,接送,等候,免费', 41),
('OTHER', '你们店在什么位置', '润达4S店位于XX市XX区XX路XX号（XX汽车城内），导航搜索"润达4S店"即可到达。附近公交线路有X路、XX路，地铁X号线XX站下车D口出步行500米。', '地址,位置,导航,交通', 42);
