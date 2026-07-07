export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
}

export interface ClientLoginResponse {
  customerId: number
  name: string
  phone: string
  grade: string
  accessToken?: string
  refreshToken?: string
  username?: string
}

export interface VehicleInfo {
  id: number
  brand: string
  model: string
  modelYear: number
  price: number
  imageUrl: string
  status: string
  vin: string
}

export interface AppointmentInfo {
  id: number
  serviceType: string
  appointmentTime: string
  status: string
  vehicleInfo: string
}

export interface PageResult<T> {
  records: T[]
  total: number
  page: number
  size: number
}
