SELECT id, brand, model,
  CASE
    WHEN image_url LIKE '%localhost:9000%' OR image_url LIKE '%114.55.225.32:9000%' THEN 'MinIO本地上传'
    WHEN image_url LIKE '/uploads/%' THEN '服务器本地文件'
    WHEN image_url LIKE 'http%' THEN '外部链接'
    ELSE '无图片'
  END as source,
  LEFT(image_url, 60) as url
FROM stock_vehicle
ORDER BY id;
