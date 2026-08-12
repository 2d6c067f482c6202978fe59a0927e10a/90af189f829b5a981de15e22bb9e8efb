# RK3588 Edge Gateway Updates

## Phạm vi

Các hướng dẫn trong file này áp dụng cho toàn bộ thư mục `rk3588/`.

Thư mục này chứa script và assets dùng để cập nhật các edge device gateway chạy
trên nền tảng RK3588. Mọi nội dung được commit tại đây có thể được public qua
GitHub; vì vậy không được lưu mật khẩu, token, private key, certificate riêng tư
hoặc dữ liệu định danh thiết bị trong thư mục này.

## Cơ chế triển khai

- `update.sh` là entrypoint public của quá trình cập nhật.
- Trên gateway, một scheduler định kỳ khoảng 10 phút một lần tải và chạy script
  trực tiếp, theo dạng `curl https://.../update.sh | sh`.
- Đây là script dành riêng cho edge device RK3588. Không giả định script có thể
  chạy trên máy dev vì máy dev có thể khác kiến trúc CPU, filesystem, service,
  quyền root, thiết bị ngoại vi và tập lệnh hệ thống.
- Vì script chạy từ pipe, không giả định repository đã được clone trên thiết bị,
  không dùng đường dẫn tương đối theo vị trí của `update.sh`, và không đọc dữ
  liệu tương tác từ stdin.
- Các thư mục/file còn lại là assets mà `update.sh` có thể tải khi cần, ví dụ:
  binary cho ARM64, file cấu hình, checksum, migration hoặc dữ liệu hỗ trợ.
- `update.sh` cũng có thể thực hiện các tác vụ bảo trì không cần asset, như dọn
  log, sửa cấu hình, dừng/disable service hoặc khởi động lại service sau update.

## Cấu trúc hiện tại

- `update.sh`: script điều phối cập nhật và bảo trì trên gateway.
- `hc-config/`: assets liên quan đến cấu hình Home Controller, gồm binary
  `MergeConfigFile`, checksum và file cấu hình nguồn/backup.

Khi thêm một nhóm cập nhật mới, đặt assets vào một thư mục con có tên rõ nghĩa
và giữ toàn bộ logic điều phối tại `update.sh` hoặc trong một script con được
`update.sh` tải về có kiểm tra tính toàn vẹn.

## Quy tắc cho `update.sh`

- Dùng POSIX `sh`; giữ shebang `#!/bin/sh`. Không dùng cú pháp riêng của Bash.
- Script phải non-interactive, idempotent và an toàn khi chạy lại mỗi 10 phút.
- Một lỗi không được để lại binary hoặc config ở trạng thái ghi dở. Tải về file
  tạm, kiểm tra checksum/chữ ký, rồi rename atomically vào đích.
- Kiểm tra kiến trúc, phiên bản hiện tại, sự tồn tại của file/service và điều
  kiện cần thiết trước khi thay đổi hệ thống.
- Chỉ tải asset bằng URL HTTPS tuyệt đối. URL phải trỏ tới nguồn/version rõ ràng;
  không suy ra URL từ working directory của process.
- Thiết lập timeout và làm cho `curl` fail khi HTTP lỗi (ví dụ `-f`), đồng thời
  giới hạn retry để một lần chạy không treo tới chu kỳ kế tiếp.
- Dùng lock nếu một lần cập nhật có thể kéo dài hơn chu kỳ 10 phút, nhằm tránh
  hai tiến trình update chạy đồng thời.
- Backup config cần thay thế và giữ nguyên owner, group, mode phù hợp. Không ghi
  đè dữ liệu do người dùng/thiết bị sinh ra nếu chưa có migration rõ ràng.
- Khi cập nhật service: chỉ stop/disable/restart service mục tiêu, kiểm tra kết
  quả, và tránh reboot thiết bị trừ khi yêu cầu cập nhật quy định rõ điều đó.
- Dọn log theo giới hạn cụ thể (đường dẫn, tuổi hoặc dung lượng); không dùng glob
  hoặc lệnh xóa đệ quy trên đường dẫn chưa được kiểm tra.
- Log ngắn gọn ra stdout/stderr với tên bước và kết quả để scheduler có thể thu
  thập. Trả exit code khác `0` khi update thất bại.
- Không in secret hoặc toàn bộ nội dung config nhạy cảm ra log.

## Quy tắc cho assets

- Binary phải tương thích Linux ARM64/aarch64 trên RK3588 và có checksum được
  commit cùng asset.
- Checksum phải bao phủ đúng bytes được tải về; cập nhật binary và checksum trong
  cùng một thay đổi.
- Config mẫu không chứa credential thật. Giá trị riêng của môi trường hoặc thiết
  bị phải được lấy từ nơi lưu trữ cục bộ/an toàn trên gateway.
- Không sửa asset sau khi đã phát hành dưới cùng một version nếu thiết bị có thể
  cache URL. Ưu tiên đường dẫn có version hoặc checksum trong tên.
- Asset lớn cần được cân nhắc về dung lượng flash, băng thông và khả năng rollback.

## Kiểm tra trước khi commit

- Chạy `sh -n rk3588/update.sh`.
- Nếu có ShellCheck, chạy `shellcheck -s sh rk3588/update.sh`.
- Trên máy dev chỉ thực hiện kiểm tra tĩnh, kiểm tra cú pháp và review logic.
  Không chạy trực tiếp `update.sh`, kể cả bằng `sh rk3588/update.sh`, nếu môi
  trường đó không phải gateway hoặc staging được chuẩn bị riêng cho việc test.
- Chỉ kiểm tra thực thi trên edge device RK3588 dùng để test hoặc môi trường
  staging mô phỏng đủ filesystem, quyền, commands và services của gateway.
- Trong môi trường test phù hợp, kiểm tra cả cách chạy thực tế qua pipe:
  `curl .../update.sh | sh` và chạy ít nhất hai lần liên tiếp để xác nhận tính
  idempotent.
- Xác minh checksum, quyền file, ownership, trạng thái service và đường rollback.
- Review toàn bộ diff để chắc chắn không có secret được đưa lên GitHub.

## Nguyên tắc thay đổi

Ưu tiên sửa ít code nhất có thể: chỉ thay đổi đúng phần cần thiết để đáp ứng yêu
cầu, không thêm abstraction, logging, biến, xử lý lỗi hoặc logic phụ khi chưa
được yêu cầu.

Mỗi thay đổi nên nhỏ, có điều kiện áp dụng rõ ràng và có thể retry. Với thay đổi
rủi ro (binary hệ thống, config chính, service thiết yếu), bổ sung version guard,
backup/rollback và health check sau update. Không biến `update.sh` thành quy trình
cài đặt một lần: mặc định mọi câu lệnh trong đó sẽ được thực thi lại sau 10 phút.
