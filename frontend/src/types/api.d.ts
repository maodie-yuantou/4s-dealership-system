export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
}

export interface LoginResponse {
  accessToken: string
  refreshToken: string
  userId: number
  username: string
  realName: string
  phone: string
  roles: string[]
  customerId?: number
}

export interface UserInfo {
  id: number
  username: string
  realName: string
  phone: string
  email: string
  avatar: string
  roles: string[]
  status: number
}

export interface PageResult<T> {
  records: T[]
  total: number
  page: number
  size: number
}

export interface PageParams {
  page: number
  size: number
  [key: string]: unknown
}
