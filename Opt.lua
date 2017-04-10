-- Optimization Package--------------------------------
-- Currently, only have simplex------------------------
Opt={}


-- 1 For Simplex---------------------------------------
--[[
1---Type of variables:
    L:number of constraints"<="
    E:....................."="
    G:.....................">="
    N:.......... variables
    F: = 1, if maximize
       =-1, if minimize
    A:coefficient matrix of the simples
      matrix is arranged in the following sequance:
      1. <=
      2. =
      3. >=
      4. objective
    Remark: initialize matrix A ???

2---How to use it
    Simplex(L,G,E,N,F,A)

3---Error information
    .....................

4---Dependent
    Matrix Lua ???

]]--

-- Simplex Core-----------------------------------------
function Opt.Simplex(L,G,E,N,F,A)
    -- Initialize Variable Value------------------------
    --local Error
    --local Stop
    Result=matrix(N,1,1e9)
    --local P,Q,S,M,W,H,B,C,R

    Initialization()

    if ( (E~=0) or (G~=0 and E==0) ) then
        BlocA()
    end
    Stop=false
    Error=0
    if ((G+E)==0) then
        BlocC()
    end

    while (not Stop) do
        if Q==0 then
        print('Q')
            if (W~=(M+1)) then
                W=W-1
            else
                i=-1
                while (not Stop and (i~=M)) do
                    i=i+1
                    if ((A[i+1][1]>=(N+G+L+1)) and (A[i+1][B+1]~=0)) then   -- Problem!!!
                        Stop=true
                        Error=2
                    end
                end
                if Error==0 then
                    BlocE()
                    print('E')
                end
                Stop=true
            end
        else
            print('B1')
            BlocB1()
            if R<0 then
                Stop=true
                Error=1
            else
                BlocB2()
                print('B2')
            end
        end
        if (not Stop) then
            BlocC()
            print('C')
        end
    end
    print(Result)
    print(Objective)

end

-- Initialization---------------------------------------
function Initialization()
    for i=1,N do
        A[L+E+G+1][i+1]=-F*A[L+E+G+1][i+1]
    end
    Error=0
    C=1
    M=L+G+E
    B=M+N+G+1
    W=M
    M=M-1
    H=1
    for k=1,(M+1) do
        A[k][N+G+k+1]=1
        A[k][1]=k+N+G
    end
end

-- BlocA------------------------------------------------
function BlocA()
    for k=(L+E+1),(M+1) do
        A[k][k-L-E+N+1]=-1
    end
    W=W+1
    Q=0
    for j=1,(N+G) do
        S=0
        for i=M-G-E+1,M do
            S=S+A[i+1][j+1]
        end
        A[W+1][j+1]=-S
        if A[W+1][j+1]<=Q then
            Q=A[W+1][j+1]
            C=j
        end
    end
end

-- BlocB1-----------------------------------------------
function BlocB1()
    H=H+1
    Q=9.9e37
    R=-1
    for i=0,M do
        if A[i+1][C+1]>0 then
            if (A[i+1][B+1]/A[i+1][C+1])<=Q then
                Q=A[i+1][B+1]/A[i+1][C+1]
                R=i
            end
        end
    end
end

-- BlocB2-----------------------------------------------
function BlocB2()
    P=A[R+1][C+1]
    A[R+1][1]=C
    for j=1,B do
        A[R+1][j+1]=A[R+1][j+1]/P
    end
    for i=0,W do
        if i~=R then
            for j=1,B do
                if j~=C then
                    A[i+1][j+1]=A[i+1][j+1]-A[R+1][j+1]*A[i+1][C+1]
                    if math.abs(A[i+1][j+1])<1e-9 then
                        A[i+1][j+1]=0
                    end
                end
            end
        end
    end
    for i=0,W do
        A[i+1][C+1]=0
    end
    A[R+1][C+1]=1
end

-- BlocC------------------------------------------------
function BlocC()
    Q=0
    for j=1,(N+G+L) do
        if A[W+1][j+1]<=Q then
            Q=A[W+1][j+1]
            C=j
        end
    end
end

-- BlocD------------------------------------------------
function BlocD()
    if (not Stop) then
        i=0
        while (not Stop and (i~=M)) do
            if ( (A[i+1][1]>=(N+G+L+1)) and (A[i+1][B+1]~=0) ) then
                Stop=true
                Error=2
            end
            i=i+1
        end
    end
end

-- BlocE------------------------------------------------
function BlocE()
    for i=1,N do
        j=0
        Stop1=false
        while ((A[j+1][1]~=i) and not Stop1) do
            if j>W+1 then
                Result[i][1]=0
                Stop1=true
            end
            j=j+1
        end
        if (not Stop1) then
            Result[i][1]=A[j+1][B+1]
        end
    end
    Objective=F*A[W+1][B+1]
end

-- Fine-------------------------------------------------
return Opt

-- -----------------------------------------------------