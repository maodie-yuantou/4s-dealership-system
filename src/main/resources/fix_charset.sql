-- 清除旧数据
DELETE FROM sys_user_role; DELETE FROM sys_role_permission; DELETE FROM sys_dict;
DELETE FROM sys_dict_type; DELETE FROM sys_permission; DELETE FROM sys_role;
DELETE FROM sys_user; DELETE FROM sys_dept; DELETE FROM kb_faq;

-- 部门
INSERT INTO sys_dept (id, parent_id, dept_name, dept_code, sort_order) VALUES
(1, 0, '总经办', 'HEAD_OFFICE', 1),(2, 0, '销售部', 'SALES', 2),(3, 0, '售后部', 'AFTERSALES', 3),
(4, 0, '市场部', 'MARKETING', 4),(5, 0, '财务部', 'FINANCE', 5),(6, 0, '行政部', 'ADMIN', 6);

-- 角色
INSERT INTO sys_role (id, role_name, role_code, description) VALUES
(1, '系统管理员', 'ADMIN', '拥有所有权限'),(2, '销售经理', 'SALES_MANAGER', '管理销售团队和线索分配'),
(3, '销售顾问', 'SALES_CONSULTANT', '跟进客户和创建订单'),(4, '售后经理', 'SERVICE_MANAGER', '管理售后团队'),
(5, '服务顾问', 'SERVICE_ADVISOR', '接车和工单管理'),(6, '技师', 'TECHNICIAN', '维修执行'),
(7, '财务', 'FINANCE', '收款、发票和结算'),(8, '店长', 'STORE_MANAGER', '查看所有报表和数据');

-- 管理员 (密码: admin123)
INSERT INTO sys_user (id, username, password, real_name, dept_id, phone) VALUES
(1, 'admin', '$2a$10$at5LxXE5e9NOVIAaCTx92.dyXYk6KPBgiTC3K/bBLO952XFDdk8yC', '系统管理员', 1, '13800000000');
INSERT INTO sys_user_role (user_id, role_id) VALUES (1, 1);

-- 权限菜单
INSERT INTO sys_permission (id, parent_id, perm_name, perm_type, path, icon, sort_order) VALUES
(1, 0, '系统管理', 'MENU', '/system', 'Setting', 1),(2, 1, '用户管理', 'MENU', '/system/users', 'User', 10),
(3, 1, '角色管理', 'MENU', '/system/roles', 'Avatar', 20),(4, 1, '权限管理', 'MENU', '/system/permissions', 'Lock', 30),
(5, 1, '部门管理', 'MENU', '/system/depts', 'OfficeBuilding', 40),(6, 1, '数据字典', 'MENU', '/system/dict', 'Collection', 50),
(7, 1, '系统参数', 'MENU', '/system/config', 'Tools', 60),(8, 1, '操作日志', 'MENU', '/system/logs', 'Document', 70),
(10, 0, '客户关系', 'MENU', '/crm', 'UserFilled', 2),(11, 10, '客户档案', 'MENU', '/crm/customers', 'UserFilled', 10),
(12, 10, '跟进记录', 'MENU', '/crm/follow-ups', 'ChatLineSquare', 20),(13, 10, '线索公海', 'MENU', '/crm/leads', 'Ship', 30),
(14, 10, '战败客户', 'MENU', '/crm/lost', 'Warning', 40),(15, 10, '提醒任务', 'MENU', '/crm/reminders', 'AlarmClock', 50),
(20, 0, '整车销售', 'MENU', '/sale', 'Sell', 3),(21, 20, '销售机会', 'MENU', '/sale/opportunities', 'Opportunity', 10),
(22, 20, '订单管理', 'MENU', '/sale/orders', 'Tickets', 20),(23, 20, '车辆交付', 'MENU', '/sale/deliveries', 'Van', 30),
(24, 20, '合同管理', 'MENU', '/sale/contracts', 'DocumentChecked', 40),
(30, 0, '库存管理', 'MENU', '/stock', 'Box', 4),(31, 30, '整车库存', 'MENU', '/stock/vehicles', 'Van', 10),
(32, 30, '入库管理', 'MENU', '/stock/inbound', 'Download', 20),(33, 30, '出库管理', 'MENU', '/stock/outbound', 'Upload', 30),
(34, 30, '配件库存', 'MENU', '/stock/accessories', 'Goods', 40),(35, 30, '盘点管理', 'MENU', '/stock/checks', 'Check', 50),
(40, 0, '售后维修', 'MENU', '/service', 'Tool', 5),(41, 40, '预约管理', 'MENU', '/service/appointments', 'Calendar', 10),
(42, 40, '维修工单', 'MENU', '/service/work-orders', 'Notebook', 20),(43, 40, '结算管理', 'MENU', '/service/settlements', 'Money', 30),
(44, 40, '回访管理', 'MENU', '/service/follow-ups', 'Phone', 40),
(50, 0, '财务结算', 'MENU', '/finance', 'Money', 6),(51, 50, '收款管理', 'MENU', '/finance/payments', 'CreditCard', 10),
(52, 50, '发票管理', 'MENU', '/finance/invoices', 'Receipt', 20),(53, 50, '退款管理', 'MENU', '/finance/refunds', 'Money', 30),
(54, 50, '应收账款', 'MENU', '/finance/receivables', 'Wallet', 40),(55, 50, '日结管理', 'MENU', '/finance/daily-settle', 'DataAnalysis', 50),
(60, 0, '统计报表', 'MENU', '/report', 'DataAnalysis', 7),(61, 60, '销售漏斗', 'MENU', '/report/sales-funnel', 'PieChart', 10),
(62, 60, '销售业绩', 'MENU', '/report/sales-performance', 'TrendCharts', 20),(63, 60, '售后业绩', 'MENU', '/report/service-performance', 'TrendCharts', 30),
(64, 60, '库存分析', 'MENU', '/report/inventory', 'Odometer', 40),(65, 60, '财务报表', 'MENU', '/report/finance', 'TrendCharts', 50),
(70, 0, '市场营销', 'MENU', '/marketing', 'Promotion', 8),(71, 70, '活动管理', 'MENU', '/marketing/campaigns', 'Flag', 10),
(72, 70, '渠道管理', 'MENU', '/marketing/channels', 'Share', 20),(73, 70, '卡券管理', 'MENU', '/marketing/coupons', 'Ticket', 30);

-- 字典类型
INSERT INTO sys_dict_type (id, dict_name, dict_code) VALUES
(1, '客户来源', 'customer_source'),(2, '客户级别', 'customer_grade'),(3, '付款方式', 'payment_method'),
(4, '车辆类型', 'vehicle_type'),(5, '订单状态', 'order_status'),(6, '线索状态', 'lead_status'),(7, '跟进方式', 'follow_method');

-- 字典数据
INSERT INTO sys_dict (dict_type_id, dict_label, dict_value, sort_order) VALUES
(1, '进店', 'WALK_IN', 1),(1, '网销', 'ONLINE', 2),(1, '外拓', 'OUTREACH', 3),
(1, '老客户介绍', 'REFERRAL', 4),(1, '车展', 'AUTO_SHOW', 5),(1, '电话', 'PHONE', 6),
(2, 'H级-1周内成交', 'H', 1),(2, 'A级-1月内成交', 'A', 2),(2, 'B级-3月内成交', 'B', 3),
(2, 'C级-半年内成交', 'C', 4),(2, 'D级-无意向', 'D', 5),
(3, '全款', 'FULL', 1),(3, '分期/贷款', 'LOAN', 2),
(4, '轿车', 'SEDAN', 1),(4, 'SUV', 'SUV', 2),(4, 'MPV', 'MPV', 3),(4, '新能源', 'EV', 4),(4, '跑车', 'SPORTS', 5),
(7, '电话', 'PHONE', 1),(7, '微信', 'WECHAT', 2),(7, '到店', 'VISIT', 3),(7, '其他', 'OTHER', 4);

-- FAQ知识库
INSERT INTO kb_faq (category, question, answer, keywords, sort_order) VALUES
('MAINTENANCE', '首保什么时候做', '新车首保一般为购车后3个月或3000-5000公里（以先到为准），具体以车辆保养手册为准。首保通常免费，包含更换机油、机滤以及全车检查。', '首保,保养,时间,公里,免费', 1),
('MAINTENANCE', '小保养和大保养有什么区别', '小保养一般指更换机油和机油滤芯，费用约500-1500元；大保养在4-6万公里时进行，在机油三滤基础上增加火花塞、变速箱油、刹车油等更换，费用约2000-8000元。', '保养,大小保养,机油,费用', 2),
('MAINTENANCE', '机油怎么选', '选择机油需看粘度等级和品质等级。普通矿物油5000公里更换，半合成油7500公里，全合成油10000公里。涡轮增压车型建议用全合成机油。我们店提供壳牌、嘉实多、美孚等品牌。', '机油,全合成,半合成,粘度', 3),
('MAINTENANCE', '刹车片多久换一次', '前刹车片一般3-5万公里更换，后刹车片5-8万公里更换。具体需根据驾驶习惯和路况而定，建议每次保养时检查刹车片厚度，厚度低于3mm需及时更换。', '刹车片,更换,公里,厚度', 4),
('INSURANCE', '新车保险怎么买', '新车需购买交强险（必买）+ 车损险 + 三者险（建议100万以上）+ 不计免赔。其他如划痕险、涉水险、自燃险按需选择。我们店合作多家保险公司，可帮您比价出单。', '保险,新车,交强险,三者险,车损险', 10),
('INSURANCE', '出险后怎么处理', '1.开启双闪，放置警示牌；2.拍照取证（全景+细节+车牌）；3.拨打保险公司电话报案；4.轻微事故可走快处快赔；5.联系我们店协助定损维修。切记不要私了后逃逸。', '出险,事故,报案,保险,处理', 11),
('INSURANCE', '保险到期前多久续保', '建议保险到期前30-45天续保，可享受最大折扣。过期未续保上路属于违法行为，且脱保超过3个月保费会上浮。我们店提供续保提醒服务。', '续保,保险到期,折扣,脱保', 12),
('PRICE', '买车落地价包含哪些费用', '落地价 = 裸车价 + 购置税（约车价除以11.3）+ 保险费（约5000-8000元）+ 上牌费（约500元）。部分车型可能还有金融服务费、精品加装费等。', '落地价,购置税,保险,上牌费,费用', 20),
('PRICE', '贷款买车和全款哪个划算', '全款购车总支出更低（无利息和手续费）；贷款购车资金压力小，但需支付利息和金融服务费（通常2000-5000元）。目前部分车型有厂家免息政策，可咨询销售顾问了解。', '贷款,全款,利息,金融服务费', 21),
('PROCESS', '提车流程是怎样的', '1.验车（外观/内饰/功能/发动机）；2.交尾款；3.购买保险；4.办理临牌；5.交车仪式；6.领取资料（发票/合格证/说明书/保养手册）。全程约2-3小时。', '提车,流程,验车,临牌,交车', 30),
('PROCESS', '车辆年检怎么办理', '新车6年内免上线检测，每2年领取检验标志；6-10年每2年上线检测一次；10-15年每年一次；15年以上每半年一次。我们店可代办年检服务。', '年检,免检,上线,代办', 31),
('PROCESS', '预约保养怎么操作', '可通过微信小程序选择保养类型（基础保养/常规检修）、到店日期和时间段，系统会自动排班。预约客户可享受优先接待服务和工时费9折优惠。', '预约,保养,小程序,排班,优惠', 32),
('OTHER', '你们店的营业时间', '销售展厅：每日9:00-18:00（节假日不休）；售后服务中心：周一至周六8:30-17:30（周日可预约紧急维修）；24小时救援电话：400-xxx-xxxx。', '营业时间,展厅,售后,救援电话', 40),
('OTHER', '有没有代步车服务', '重大维修（超过48小时）可申请免费代步车，需提前预约。小修和保养提供免费茶歇和WiFi等候区，也可安排免费接送服务。', '代步车,接送,等候,免费', 41),
('OTHER', '你们店在什么位置', '润达4S店位于XX市XX区XX路XX号（XX汽车城内），导航搜索润达4S店即可到达。附近公交线路有X路、XX路，地铁X号线XX站下车D口出步行500米。', '地址,位置,导航,交通', 42);
