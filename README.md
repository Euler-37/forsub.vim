# forsub.vim

`imap <M-p> <ESC>:ProcedureConvert<cr>zR^%O`

# Intro

This plugin is for quick input for fortran subroutines and funcions.

example:

`sub:test,tco foo self,isi i,rdi d`
``` fortran
subroutine test(self, i, d)
    class(foo),intent(inout)::self
    integer(kind=4),intent(in)::i
    real(kind=8),intent(in)::d
    |
end subroutine test
```
fun:test,tco foo self,isi i,rdi d,rd s

``` fortran
function test(self, i, d) result(s)
    class(foo),intent(inout)::self
    integer(kind=4),intent(in)::i
    real(kind=8),intent(in)::d
    real(kind=8)::s
    |
end function test
```
The abbreviations have three items and a dummy name

- 1 type name 
  - i : `integer`
  - r : `real`
  - c ：`complex`
  - s : `character`
  - l : `logical`
  - tt : `type`
  - tc : `class`
- 2 kind parameter
  - s : `kind=4`
  - d : `kind=8`
  - l : `len=*`
- 3 intent property
  - o : intent(inout)
  - i : intent(in)
 
- remarks:
  - split with comma ','
  - function's result doesn't have intent property
  - depend on `matchit`
