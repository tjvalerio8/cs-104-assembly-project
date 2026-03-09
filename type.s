.intel_syntax noprefix		# Please keep this
.text				# Please keep this
.globl	main			# Please keep this
main:				# Start of the main function

	# Check for exactly 2 arguments (program name + filename)
	# rdi holds the argument count when main starts
	cmp	rdi, 2		# Compare argument count to 2
	jne	error		# If not 2, go to error

	# Get the filename (second argument = index 1 in rsi array)
	mov	rdi, [rsi + 8]	# Get file name to open

	# Tell open to read-only (0 = read only)
	mov	rsi, 0		# Second argument: open mode = 0 (read only)
	mov	rax, 2		# Put 2 (open) into function number
	syscall			# Call open with 2 arguments

	# Check if open failed (returns -1 on failure)
	cmp	rax, 0		# Compare result to 0
	jl	error		# If less than 0, go to error

	# Save the file descriptor to rbx
	mov	rbx, rax	# Save file descriptor

	# Give ourselves 8 bytes of space on the stack
	sub	rsp, 8		# Subtract 8 from rsp to make room

loop:				# Start of the loop function

	# Set up 3 arguments for read:
	mov	rdi, rbx	# First argument: file descriptor
	mov	rsi, rsp	# Second argument: buffer (our 8 bytes)
	mov	rdx, 1		# Third argument: read 1 byte

	mov	rax, 0		# Put 0 (read) into function number
	syscall			# Call read with 3 arguments

	# Check what read gave back
	cmp	rax, 0		# Compare to 0
	je	done		# If 0, end of file, go to done
	jl	error		# If less than 0, something went wrong

	# Write the character to the screen
	mov	rdi, 1		# First argument: 1 = screen (stdout)
	mov	rsi, rsp	# Second argument: buffer
	mov	rdx, 1		# Third argument: write 1 byte

	mov	rax, 1		# Put 1 (write) into function number
	syscall			# Call write with 3 arguments

	# Check that write returned 1
	cmp	rax, 1		# Compare result to 1
	jne	error		# If not 1, something went wrong

	# Loop back to read the next character
	jmp	loop		# Jump back to top of loop

done:				# Start of the done function
	mov	rdi, 0		# First argument: 0 = success

	mov	rax, 60		# Put 60 (exit) into function number
	syscall			# Call exit with an argument of 0

error:				# Start of the error function
	mov	rdi, 1		# Put 1 into first argument
	mov	rax, 60		# Put 60 (exit) into function number
	syscall			# Call exit with an argument of 1
