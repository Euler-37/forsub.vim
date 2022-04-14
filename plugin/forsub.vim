" forsub.vim
" Author:      Euler-37
" Version:      0.0.1

if exists("g:loaded_forsub") || &cp || v:version < 700
  finish
endif
let g:loaded_forsub = 1

"----------------------------------------------"
" fortran fast subroutine and function input
"----------------------------------------------"
"" sub:test,tco spin self,isi i,rdi d
"" fun:test,tco spin self,isi i,rdi d,rd s
command! -nargs=0 ProcedureConvert call ProcedureConvertVim()
function! ProcedureConvertVim()
python3 <<EOF
ParaType={"i":"integer","r":"real","c":"complex","s":"character","l":"logical","tt":"type","tc":"class"}
ParaKind={"s":"(kind=4)","d":"(kind=8)","l":"(len=*)"}
ParaInout={"o":",intent(inout)","i":",intent(in)"}
def ProcedureParse(InputStr):
    SplitStr=InputStr.split(",")
    if(SplitStr[0][0:3]=="sub"):
        # sub str,iso:a,cso:b
        temp=["subroutine ",SplitStr[0][4:],"("]
        ParaDefine=[]
        for s in SplitStr[1:]:
            if s[0]!="t":
                ParaDefine.append("".join([ParaType[s[0]],ParaKind[s[1]],ParaInout[s[2]],"::",s[4:]]))
                temp.append(s[4:])
            else:
                tempS=s[2:].split(" ")
                ParaDefine.append("".join([ParaType[s[0:2]],"(",tempS[1],")",ParaInout[tempS[0]],"::",tempS[2]]))
                temp.append(tempS[2])
            temp.append(", ")
        if(temp[-1]!="("):
            temp.pop()
        temp.append(")")
        Title="".join(temp)
        ParaDefine.insert(0,Title)
        ParaDefine.append("".join(["end subroutine ",SplitStr[0][4:]]))
        return ParaDefine
    elif(SplitStr[0][0:3]=="fun"):
        temp=["function ",SplitStr[0][4:],"("]
        ParaDefine=[]
        for s in SplitStr[1:len(SplitStr)-1]:
            if s[0]!="t":
                ParaDefine.append("".join([ParaType[s[0]],ParaKind[s[1]],ParaInout[s[2]],"::",s[4:]]))
                temp.append(s[4:])
            else:
                tempS=s[2:].split(" ")
                ParaDefine.append("".join([ParaType[s[0:2]],"(",tempS[1],")",ParaInout[tempS[0]],"::",tempS[2]]))
                temp.append(tempS[2])
            temp.append(", ")
        s=SplitStr[len(SplitStr)-1]
        if s[0]!="t":
            ParaDefine.append("".join([ParaType[s[0]],ParaKind[s[1]],"::",s[3:]]))
            Res=s[3:]
        else:
            tempS=s[3:].split(" ")
            ParaDefine.append("".join([ParaType[s[0:2]],"(",tempS[0],")","::",tempS[1]]))
            Res=tempS[1]
        #ParaDefine.append("".join([ParaType[s[0]],ParaKind[s[1]],"::",s[3:]]))
        if(temp[-1]!="("):
            temp.pop()
        temp.append(") result(")
        temp.append(Res)
        temp.append(")")
        Title="".join(temp)
        ParaDefine.insert(0,Title)
        ParaDefine.append("".join(["end function ",SplitStr[0][4:]]))
        return ParaDefine
    else:
        print("Error: ProcedureParse")
        return None
def main():
    #currentline=vim.eval("getline('.')")
    currentline=vim.current.line
    spaces=len(currentline)-len(currentline.strip())
    output=ProcedureParse(currentline.strip())
    #print(output)
    space=" "*spaces
    vim.command("".join(["call setline(line('.')",",'",space,output[0],"')"]))
    for ii,s in enumerate(output[1:len(output)-1]):
        vim.command("".join(["call append(line('.')+",str(ii),",'",space," "*4,s,"')"]))
    vim.command("".join(["call append(line('.')+",str(len(output)-2),",'",space,output[len(output)-1],"')"]))
main()
EOF
endfunction
" vim:set ft=vim sw=4 sts=4 et:
