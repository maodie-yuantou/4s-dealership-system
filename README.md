<div align="center">
  <h1>润达 4S 店管理系统</h1>
  <p>Spring Boot 3.2 + Vue 3 全栈汽车经销商管理系统</p>
</div>

---

## 项目简介

一套完整的汽车 4S 店业务管理系统，覆盖整车销售、客户关系管理、库存管理、售后维修、财务结算、市场营销等核心模块。提供管理后台（PC 端）和客户小程序（移动端）双端界面。

## 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 后端框架 | Spring Boot | 3.2.5 |
| 安全框架 | Spring Security + JWT | 6.2 / 0.12 |
| ORM | MyBatis-Plus | 3.5.7 |
| 数据库 | MySQL | 8.0 |
| 缓存 | Redis | 7.0 |
| 对象存储 | MinIO | latest |
| 反向代理 | Nginx | alpine |
| 接口文档 | Knife4j (Swagger) | 4.5 |
| AI 对话 | LangChain4j + DeepSeek | 0.34 |
| 前端框架 | Vue 3 + Vite | 5.x |
| UI 组件库 | Element Plus / Vant 4 | 2.7 / 4.x |
| 状态管理 | Pinia | 2.1 |
| 图表 | ECharts 5 + vue-echarts | 5.5 / 6.6 |
| 容器化 | Docker + Docker Compose | — |

## 系统架构

```
┌────────────────────────────────────────────────────────┐
│                       Nginx (80)                        │
│         反向代理 · 负载均衡 · 静态资源           │
└──────┬──────────────────────────────────┬──────────────┘
       │                                  │
       ▼                                  ▼
┌──────────────┐                 ┌──────────────┐
│  Admin SPA   │                 │ Client H5    │
│  Vue3 + EP   │                 │  Vue3 + Vant │
│  :5173       │                 │  :5174       │
└──────┬───────┘                 └──────┬───────┘
       │                                │
       └──────────┬─────────────────────┘
                  │ REST API (:8080)
                  ▼
┌──────────────────────────────────────┐
│          Spring Boot 3.2              │
│  ┌──────────────────────────┐        │
│  │     Security Layer       │        │
│  │  JWT + RBAC 权限控制     │        │
│  ├──────────────────────────┤        │
│  │   Business Modules       │        │
│  │  CRM │ 销售 │ 库存 │ 售后  │        │
│  │  财务 │ 报表 │ 营销 │ 商城  │        │
│  ├──────────────────────────┤        │
│  │  MyBatis-Plus + Redis    │        │
│  └──────────────────────────┘        │
└──────┬──────┬────────┬───────────────┘
       │      │        │
       ▼      ▼        ▼
┌────────┐ ┌──────┐ ┌──────┐
│ MySQL  │ │Redis │ │MinIO │
│ :3307  │ │:6379 │ │:9000 │
└────────┘ └──────┘ └──────┘
```

## 功能模块

| 模块 | 功能 |
|------|------|
| **系统管理** | 用户/角色/权限(RBAC)、部门管理、数据字典、操作日志 |
| **客户关系** | 客户档案、跟进记录、线索公海、战败分析、提醒任务 |
| **整车销售** | 销售机会、订单管理、车辆交付、合同管理 |
| **库存管理** | 整车入库/出库、库存查询、配件管理、盘点 |
| **售后维修** | 预约管理、维修工单、结算、回访 |
| **财务结算** | 收款管理、发票管理、退款、应收账款、日结 |
| **统计报表** | 销售漏斗、销售/售后业绩、库存分析、财务报表 |
| **市场营销** | 活动管理、渠道管理、卡券管理 |
| **AI 智能客服** | DeepSeek 大模型对话、常见问题知识库 |
| **精品商城** | 保养套餐、配件、精品销售 |

## 快速启动

### 环境要求

- JDK 17+
- Maven 3.8+
- Docker Desktop
- Node.js 18+

### 1. 启动基础服务

```bash
# 启动 Redis、Nginx、MinIO
docker-compose up -d

# 确保 MySQL 在 3307 端口运行（本地已有 mysql-project 容器）
docker start mysql-project
```

### 2. 启动后端

```bash
mvn spring-boot:run
# 或 IDEA 中运行 Application.java
```

### 3. 启动前端

```bash
# 管理后台 (http://localhost:5173)
cd frontend && npm install && npm run dev

# 客户端 (http://localhost:5174)
cd frontend-client && npm install && npm run dev
```

### 4. 访问

| 地址 | 说明 |
|------|------|
| http://localhost:5173 | 管理后台 |
| http://localhost:5174 | 客户小程序 |
| http://localhost:8080 | 后端 API |
| http://localhost:8080/doc.html | API 文档 (Knife4j) |
| http://localhost:9001 | MinIO 控制台 |

### 5. 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 系统管理员 | `admin` | `admin123` |
| 销售经理 | `zhangsan` | `123456` |
| 店长 | `zhengshi` | `123456` |

### 6. 运行测试

```bash
mvn test
```

## 数据库 ER 模型（核心表）

```
sys_user ──< sys_user_role >── sys_role ──< sys_role_permission >── sys_permission
   │
   ├──< crm_customer ──< crm_follow_up
   ├──< crm_lead
   ├──< sale_order
   ├──< svc_appointment ──< svc_work_order
   │
stock_vehicle ──< sale_order
   │
fin_payment ──< sale_order
   │
mkt_campaign ──< mkt_coupon
```

## 项目亮点

- **完整业务闭环**：集客 → 跟进 → 试驾 → 下单 → 交付 → 售后 → 回访
- **RBAC 权限体系**：8 种角色，73 个权限节点，细粒度控制
- **前后端分离**：管理后台 + 移动端 H5，RESTful API 统一接口
- **AI 集成**：DeepSeek 大模型智能客服 + FAQ 知识库
- **Docker 容器化**：MySQL + Redis + Nginx + MinIO 一键编排
- **生产级安全**：JWT 无状态认证、密码 BCrypt 加密、操作日志审计
- **接口文档**：Knife4j 自动生成，在线调试

---

<div align="center">
  <sub>Built with Spring Boot 3.2 · Vue 3 · Docker</sub>
</div>
