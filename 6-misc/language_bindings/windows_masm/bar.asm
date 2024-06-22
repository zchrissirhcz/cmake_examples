; bar.asm
.code
public add1
add1 proc input:dword
    mov eax, input
    add eax, 1
    ret
add1 endp
end
