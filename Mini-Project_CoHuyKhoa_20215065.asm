# Cồ Huy Khoa 20215065
# Mini Project 08
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

.data
Message: .asciiz "Enter the number of students in class(>0): "
Message1: .asciiz "Enter the name of student(<30 characters): "
Message2: .asciiz "Enter the math mark (0-10) of student: "
Message3: .asciiz "List of students sorted by their mark: \n"
Message4: .asciiz "Enter the character: ! if you want to escape at name entry"
Message5: .asciiz "Enter: -1 if you want to escape at mark entry and the number of students entry"
list_mark_compare: .float 10 0 -1		# Khai báo số thực điểm min = 0, max = 10 có thể nhập vào và số đánh dấu thoát chương trình = -1
marks: .space 10000
names: .space 10000
.text	
	li $v0, 55				# In chuỗi Message4
	la $a0, Message4			# Gán địa chỉ $a0 với chuỗi Message4
	syscall
	li $v0, 55				# In chuỗi Message5
	la $a0, Message5			# Gán địa chỉ $a0 với chuỗi Message5
	syscall
loop_number_student:
	li $v0, 51				# In chuỗi Message
	la $a0, Message				# Gán địa chỉ $a0 với chuỗi Message
	syscall
	
# Check điều kiện input số lượng học sinh
	add $s0, $a0, $zero 			# s0 = số lượng học sinh
	beq $s0, -1, end
	slt $t1, $zero, $s0			# Nếu s0 >0 thì t1 = 1 (bao gồm hiện tượng tràn số xáy ra)
	beq $t1, $zero, loop_number_student	# Nhảy đến nhãn loop_number_student nếu t1 = 0 (Nhập lại)
	beq $a1, -1, loop_number_student	# Nếu số nhập vào không hợp lệ (không phải số nguyên) thì $a1 mặc định sẽ bằng -1
	add $t6, $s0, $zero
	li $v0, 9				# Khai báo mảng động
	la $a3, marks				# a3 = marks[0]
	syscall	
	li $v0, 9				# Khai báo mảng động
	la $s2, names				# s2 = names[0]
	syscall
loop_input:
	li $v0, 54				# In chuỗi Message1
	la $a0, Message1			# Gán địa chỉ $a0 với chuỗi Message1
	la $a1, 0($s2)				# Gán địa chỉ phần tử chuỗi đã khai báo vào chuỗi đã nhập ở $a1
	la $a2, 30				# Số kí tự tối đa nhập vào tên là 30
	syscall

# Check điều kiện input tên
	addi $t2, $s2, 0			# Gán địa chỉ $t2 bằng địa chỉ mảng tên
	li $t3, 0				# Khai báo t3 = 0 là chỉ số duyệt mảng tên
	li $t5, 65				# Khai báo t5 = 65 là mã ascii hệ 10 của chữ cái A
	li $t7, 90				# Khai báo t7 = 90 là mã ascii hệ 10 của chữ cái Z
	li $t8, 97				# Khai báo t8 = 97 là mã ascii hệ 10 của chữ cái a
	li $t9, 122				# Khai báo t9 = 122 là mã ascii hệ 10 của chữ cái z
L3: 	lb $t4, 0($t2)				# Load từng kí tự của tên đang xét ra $t4 
	li $t0, 0				# Gán t0 = 0
	slt $t1, $t0, $t3			# Nếu số kí tự đã load ra > 0 thì t1 = 1
	beq $t1, 1, continue			# Nếu t1 = 1 thì nhảy đến nhãn continue (không xét điều kiện thoát khi nhập !)
	beq $t4, 33, end_loop_name		# Nếu t1 = 0 thì chứng tỏ kí tự đầu nhập vào là ! nhảy đến nhãn end_loop_name
	j continue				# Nhảy đến nhãn continue khi kí tự đầu nhập vào không là !
end_loop_name:
	addi $t2, $t2, 1			# Tăng t2 lên 1 byte xét kí tự tiếp theo
	lb $t4, 0($t2)				# Load kí tự tiếp theo ra $t4
	beq $t4, 10, end			# Nếu kí tự load ra có mã ascii hệ 10 = 10(kí tự xuống dòng) thì nhảy đến nhãn end kết thúc chương trình
	j loop_input				# Nếu không thì nhảy đến nhãn loop_input do kí tự ngay sau ! không kết thúc chuỗi nên không kết thúc chương trình và nhập lại chuỗi
continue:
	beq $t4, 32, continue1			# Nếu kí tự vừa load ra có mã ascii hệ 10 = 32(kí tự dấu cách) thì nhảy đến nhãn continue1 bỏ qua xét điều kiện dưới
	beq $t4, 10, loop_mark			# Nếu kí tự vừa load ra có mã ascii hệ 10 = 10(kí tự xuống dòng) thì nhảy đến nhãn loop_mark nhập điểm	
	slt $t0, $t4, $t5			# t0 = 0 khi kí tự load ra có mã ascii hệ 10 >= kí tự A	
	slt $t1, $t7, $t4			# t1 = 0 khi kí tự load ra có mã ascii hệ 10 <= kí tự Z
	or $s6, $t0, $t1			# s6 = 0 khi kí tự load ra có mã ascii hệ 10 nằm trong đoạn [65,90]
	slt $t0, $t4, $t8			# t0 = 0 khi kí tự load ra có mã ascii hệ 10 >= kí tự a		
	slt $t1, $t9, $t4			# t1 = 0 khi kí tự load ra có mã ascii hệ 10 <= kí tự z	
	or $s7, $t0, $t1			# s7 = 0 khi kí tự load ra có mã ascii hệ 10 nằm trong đoạn [97,122]
	and $s5, $s6, $s7			# s5 = 0 khi kí tự load ra có mã ascii hệ 10 hoặc nằm trong đoạn [65,90](s6 = 0) hoặc nằm trong đoạn [97,122](s7 = 0)
	beq $s5, 1, loop_input			# Nếu kí tự load ra không nằm trong các kí tự từ a-z hoặc từ A-Z thì yêu cầu người dùng nhập lại
continue1:
	addi $t2, $t2, 1			# Tăng t2 lên 1 byte xét kí tự tiếp theo trong tên
	addi $t3, $t3, 1			# Tăng t3 lên 1 byte 
 	bne $t3, 30, L3				# Dừng khi xét hết 30 kí tự
loop_mark:
	li $v0, 52				# In chuỗi Message2
	la $a0, Message2			# Gán địa chỉ $a0 với chuỗi Message2
	syscall
	
# Check điều kiện input điểm
	la $s3, list_mark_compare		# Gán địa chỉ $s3 bằng địa chỉ chuỗi chứa 2 số thực điểm min = 0, max = 10
	lwc1 $f2, 0($s3)			# Load số đầu tiên trong chuỗi = 10 ra $f2
	lwc1 $f1, 4($s3)			# Load số thứ hai trong chuỗi = 0 ra $f1
	lwc1 $f10, 8($s3)			# Load số thứ ba trong chuỗi = -1 ra $f1
	c.eq.s $f0, $f10			# So sánh số thực nhập vào từ bàn phím với -1
	bc1t end 				# Nếu nhập vào số = -1 thì thoát chương trình
	c.lt.s $f0, $f1				# So sánh số thực nhập vào từ bàn phím với 0
	bc1t loop_mark				# Nếu điểm nhập vào nhỏ hơn 0 thì nhảy đến nhãn loop_mark nhập lại điểm
	c.lt.s $f2, $f0				# So sánh số thực nhập vào từ bàn phím với 10
	bc1t loop_mark				# Nếu điểm nhập vào lớn hơn 10 thì nhảy đến nhãn loop_mark nhập lại điểm
	beq $a1, -1, loop_mark			# Nếu số nhập vào không hợp lệ (không phải số thực hoặc gây ra hiện tượng tràn số) thì $a1 mặc định sẽ bằng -1			
	swc1 $f0, 0($a3)			# Nếu nhập điểm thỏa mãn thì lưu điểm nhập vào mảng điểm đang xét
	li $t1, 1				# Khai báo t1 = 1
	beq $s0, $t1, print			# Nếu số lượng học sinh bằng 1 thì in ra thông tin
	addi $s2, $s2, 30			# Xét đến phần tử tiếp theo trong mảng chứa tên
	addi $a3, $a3, 4			# Tăng $a3 lên 4 byte duyệt phần tử tiếp theo của mảng điểm
	subi $t6, $t6, 1			# Giảm $t6 đi 1 byte đến khi bằng 0 thì dừng
	slti $t0, $t6, 1			# Nếu $t6 < 1 thì t0 = 1
	beq $t0, $zero, loop_input		# Quay lại nhập thông tin học sinh mới nếu $t0 = 0
	
	
# Sắp xếp danh sách học sinh theo điểm
	add $s3, $s0, $zero			# Lưu trữ số học sinh (điều kiện cho 2 vòng lặp dừng)
	subi $t8, $s3, 1			# Điều kiện dừng vòng lặp trong
	subi $t9, $s3, 2			# Điều kiện dừng vòng lặp ngoài
	la $t2, marks 				# Đưa địa chỉ của mảng điểm vào thanh ghi $t2
    	li $t3, 0 				# Khởi tạo biến đếm $t3 = 0 của vòng lặp mới
    	la $s1, names				# Đưa địa chỉ phần tử đầu tiên của mảng vào thanh ghi $t1
loop_sort:
	move $t5, $zero
	move $s2, $zero				
	addi $t5, $t3, 1			# Khởi tạo biến đếm $t5 = 1 của vòng lặp so sánh
        addi $s2, $s1, 30 			# Đưa địa chỉ phần tử tiếp theo của mảng vào thanh ghi $s2
        addi $t4, $t2, 4 			# Đưa địa chỉ của phần tử điểm kế tiếp vào thanh ghi $t4 
loop_compare:
        lwc1 $f6, 0($t2)		  	# Đọc giá trị điểm hiện tại vào thanh ghi $t6
        lwc1 $f7, 0($t4) 			# Đọc giá trị điểm kế tiếp vào thanh ghi $t7

        c.lt.s $f7, $f6				# So sánh nếu điểm kế tiếp nhỏ hơn điểm hiện tại thì trả về true
        bc1t next_compare			# Nếu điểm hiện tại lớn hơn hoặc bằng điểm kế tiếp thì bỏ qua
        
	#Hoán đổi điểm
        swc1 $f6, 0($t4) 			# Load điểm hiện tại vào điểm kế tiếp	
        swc1 $f7, 0($t2)			# Load điểm kế tiếp vào điểm hiện tại
        
	#Hoán đổi tên
    	move $s4, $zero				
    	move $t0, $zero
    	move $t1, $zero
    	add $t0, $s1, $zero			# Thanh ghi duyệt kí tự chuỗi thứ nhất
    	add $t1, $s2, $zero			# Thanh ghi duyệt kí tự chuỗi thứ hai
L1: 
    	lb $s5, 0($t0)				# Load từng kí tự chuỗi thứ nhất ra $s5
    	lb $s6, 0($t1)				# Load từng kí tự chuỗi thứ hai ra $s6
    
    	sb $s6, 0($t0)				# Load từng kí tự chuỗi thứ nhất vào chỉ số tương ứng vào chuỗi thứ hai
    	sb $s5, 0($t1)				# Load từng kí tự chuỗi thứ hai vào chỉ số tương ứng vào
    	
    	addi $t0, $t0, 1			# Tăng giá trị thanh ghi duyệt chuỗi thứ nhất lên 1
    	addi $t1, $t1, 1			# Tăng giá trị thanh ghi duyệt chuỗi thứ hai lên 1
    	addi $s4, $s4, 1			# Tăng giá trị thanh ghi duyệt điều kiện dừng lên 1
    	bne $s4, 30, L1				# Kết thúc xét 
    	
    	# Duyệt vòng lặp so sánh
next_compare:
        addi $s2, $s2, 30			# Duyệt phần tử tiếp theo của mảng chuỗi (Tăng lên 30 byte)
        addi $t5, $t5, 1 			# Tăng biến đếm lên 1
        addi $t4, $t4, 4 			# Tăng địa chỉ của phần tử điểm kế tiếp lên 4 byte
        bne $t5, $s3, loop_compare		# Nếu biến đếm chưa đủ số lượng học sinh thì quay lại vòng lặp so sánh
	
	# Duyệt vòng lặp mới
	addi $s1, $s1, 30 			# Duyệt phần tử tiếp theo của mảng chuỗi (Tăng lên 30 byte)
    	addi $t2, $t2, 4 			# Tăng địa chỉ của phần tử điểm hiện tại lên 4 byte
   	addi $t3, $t3, 1 			# Tăng biến đếm lên 1
   	bne $t3, $t8, loop_sort 		# Nếu biến đếm chưa đủ số lượng học sinh thì qua vòng lặp mới
  

# In tên học sinh và điểm đã sắp xếp
print:
	li $v0 ,4				# In ra chuỗi Message3
	la $a0, Message3			# Gán địa chỉ $a0 với chuỗi Message3
	syscall
	move $t1, $zero
	move $s1, $zero
	add $s1, $s0, $zero			# Gán số lượng học sinh (điều kiện dừng)
	la $t2, names				# Khai báo mảng tên 
	la $t3, marks				# Khai báo mảng điểm
	li $t0, 10				# Khai báo giá trị kí tự xuống dòng
L2:	
	addi $t6, $t2, 0			# Khai báo địa chỉ chuỗi tên học sinh đầu tiên chuỗi đã sắp xếp
loop:
	lb $t4, 0($t6)				# Load từng kí tự của tên đang xét
	beq $t4, $t0, end_loop			# Nếu gặp kí tự xuống dòng thì nhảy đến nhãn end_loop thực hiện in điểm
	li $v0, 11				# In từng kí tự của tên đang xét
	move $a0, $t4				# Gán kí tự in vào $a0 mặc định là kí tự in 
	syscall
	addi $t6, $t6, 1			# Tăng giá trị $t6 lên 1 in kí tự tiếp theo
	j loop
end_loop:
	li $v0, 11 				# In dấu cách
	li $a0, 32				# Khai báo mã dấu cách
	syscall					
	li $v0, 2				# In điểm từng học sinh
	lwc1 $f12, 0($t3)			# Load điểm từ mảng điểm ra $f12
        syscall
        li $v0, 11				# In dấu xuống dòng (thông tin mỗi sinh viên trên 1 dòng)
        li $a0, 10				# Khai báo mã dấu xuống dòng
        syscall
        addi $t3, $t3 ,4			# Tăng giá trị $t3 lên 4 byte duyệt điểm học sinh tiếp theo
	addi $t1, $t1, 1			# Tăng giá trị $t1 lên 1 byte duyệt điều kiện dừng
	addi $t2, $t2, 30			# Tăng giá trị $t2 lên 10 byte duyệt tên học sinh tiếp theo
	bne $t1, $s1, L2			# Vòng lặp dừng khi duyệt qua tất cả các học sinh
end:
	li $v0, 10				# Thoát 
	syscall
	

