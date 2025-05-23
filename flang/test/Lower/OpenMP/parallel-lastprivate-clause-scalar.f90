! This test checks lowering of `LASTPRIVATE` clause for scalar types.

! RUN: bbc -fopenmp -emit-hlfir %s -o - | FileCheck %s
! RUN: flang -fc1 -fopenmp -emit-hlfir %s -o - | FileCheck %s

!CHECK: func @_QPlastprivate_character(%[[ARG1:.*]]: !fir.boxchar<1>{{.*}}) {
!CHECK-DAG: %[[ARG1_UNBOX:.*]]:2 = fir.unboxchar
!CHECK-DAG: %[[FIVE:.*]] = arith.constant 5 : index
!CHECK-DAG: %[[ARG1_REF:.*]] = fir.convert %[[ARG1_UNBOX]]#0 : (!fir.ref<!fir.char<1,?>>) -> !fir.ref<!fir.char<1,5>>
!CHECK-DAG: %[[ARG1_DECL:.*]]:2 = hlfir.declare %[[ARG1_REF]] typeparams %[[FIVE]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFlastprivate_characterEarg1"} : (!fir.ref<!fir.char<1,5>>, index, !fir.dscope) -> (!fir.ref<!fir.char<1,5>>, !fir.ref<!fir.char<1,5>>)

!CHECK: omp.parallel {

! Check that we are accessing the clone inside the loop
!CHECK: omp.wsloop private(@{{.*}} %{{.*}}#0 -> %[[ARG1_PVT:.*]], @{{.*}} %{{.*}}#0 -> %{{.*}} : !fir.ref<!fir.char<1,5>>, !{{.*}}) {
!CHECK-NEXT: omp.loop_nest (%[[INDX_WS:.*]]) : {{.*}} {
!CHECK: %[[FIVE:.*]] = arith.constant 5 : index
!CHECK: %[[ARG1_PVT_DECL:.*]]:2 = hlfir.declare %[[ARG1_PVT]] typeparams %[[FIVE]] {uniq_name = "_QFlastprivate_characterEarg1"} : (!fir.ref<!fir.char<1,5>>, index) -> (!fir.ref<!fir.char<1,5>>, !fir.ref<!fir.char<1,5>>)
!CHECK: %[[UNIT:.*]] = arith.constant 6 : i32
!CHECK-NEXT: %[[ADDR:.*]] = fir.address_of(@_QQclX
!CHECK-NEXT: %[[CVT0:.*]] = fir.convert %[[ADDR]] 
!CHECK-NEXT: %[[CNST:.*]] = arith.constant
!CHECK-NEXT: %[[CALL_BEGIN_IO:.*]] = fir.call @_FortranAioBeginExternalListOutput(%[[UNIT]], %[[CVT0]], %[[CNST]]) {{.*}}: (i32, !fir.ref<i8>, i32) -> !fir.ref<i8>
!CHECK-NEXT: %[[CVT_0_1:.*]] = fir.convert %[[ARG1_PVT_DECL]]#0 
!CHECK-NEXT: %[[CVT_0_2:.*]] = fir.convert %[[FIVE]]
!CHECK-NEXT: %[[CALL_OP_ASCII:.*]] = fir.call @_FortranAioOutputAscii(%[[CALL_BEGIN_IO]], %[[CVT_0_1]], %[[CVT_0_2]])
!CHECK-NEXT: %[[CALL_END_IO:.*]] = fir.call @_FortranAioEndIoStatement(%[[CALL_BEGIN_IO]])

! Testing last iteration check
!CHECK: %[[V:.*]] = arith.addi %[[INDX_WS]], %{{.*}} : i32
!CHECK: %[[C0:.*]] = arith.constant 0 : i32
!CHECK: %[[T1:.*]] = arith.cmpi slt, %{{.*}}, %[[C0]] : i32
!CHECK: %[[T2:.*]] = arith.cmpi slt, %[[V]], %{{.*}} : i32
!CHECK: %[[T3:.*]] = arith.cmpi sgt, %[[V]], %{{.*}} : i32
!CHECK: %[[IV_CMP:.*]] = arith.select %[[T1]], %[[T2]], %[[T3]] : i1
!CHECK: fir.if %[[IV_CMP]] {
!CHECK: hlfir.assign %[[V]] to %{{.*}} : i32, !fir.ref<i32>

! Testing lastprivate val update
!CHECK: hlfir.assign %[[ARG1_PVT_DECL]]#0 to %[[ARG1_DECL]]#0 : !fir.ref<!fir.char<1,5>>, !fir.ref<!fir.char<1,5>>
!CHECK: }
!CHECK: omp.yield
!CHECK: }
!CHECK: }

subroutine lastprivate_character(arg1)
        character(5) :: arg1
!$OMP PARALLEL 
!$OMP DO LASTPRIVATE(arg1)
do n = 1, 5
        arg1(n:n) = 'c'
        print *, arg1
end do
!$OMP END DO
!$OMP END PARALLEL
end subroutine

!CHECK: func @_QPlastprivate_int(%[[ARG1:.*]]: !fir.ref<i32> {fir.bindc_name = "arg1"}) {
!CHECK: %[[ARG1_DECL:.*]]:2 = hlfir.declare %[[ARG1]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFlastprivate_intEarg1"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK-DAG: omp.parallel  {
!CHECK: omp.wsloop private(@{{.*}} %{{.*}}#0 -> %[[CLONE:.*]], @{{.*}} %{{.*}}#0 -> %{{.*}} : !fir.ref<i32>, !{{.*}}) {
!CHECK-NEXT: omp.loop_nest (%[[INDX_WS:.*]]) : {{.*}} {
!CHECK:      %[[CLONE_DECL:.*]]:2 = hlfir.declare %[[CLONE]] {uniq_name = "_QFlastprivate_intEarg1"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)

! Testing last iteration check
!CHECK: %[[V:.*]] = arith.addi %[[INDX_WS]], %{{.*}} : i32
!CHECK: %[[C0:.*]] = arith.constant 0 : i32
!CHECK: %[[T1:.*]] = arith.cmpi slt, %{{.*}}, %[[C0]] : i32
!CHECK: %[[T2:.*]] = arith.cmpi slt, %[[V]], %{{.*}} : i32
!CHECK: %[[T3:.*]] = arith.cmpi sgt, %[[V]], %{{.*}} : i32
!CHECK: %[[IV_CMP:.*]] = arith.select %[[T1]], %[[T2]], %[[T3]] : i1
!CHECK: fir.if %[[IV_CMP]] {
!CHECK: hlfir.assign %[[V]] to %{{.*}} : i32, !fir.ref<i32>

! Testing lastprivate val update
!CHECK-NEXT: %[[CLONE_LD:.*]] = fir.load %[[CLONE_DECL]]#0 : !fir.ref<i32>
!CHECK:      hlfir.assign %[[CLONE_LD]] to %[[ARG1_DECL]]#0 : i32, !fir.ref<i32>
!CHECK: }
!CHECK: omp.yield
!CHECK: }
!CHECK: }

subroutine lastprivate_int(arg1)
        integer :: arg1
!$OMP PARALLEL 
!$OMP DO LASTPRIVATE(arg1)
do n = 1, 5
        arg1 = 2
        print *, arg1
end do
!$OMP END DO
!$OMP END PARALLEL
print *, arg1
end subroutine

!CHECK: func.func @_QPmult_lastprivate_int(%[[ARG1:.*]]: !fir.ref<i32> {fir.bindc_name = "arg1"}, %[[ARG2:.*]]: !fir.ref<i32> {fir.bindc_name = "arg2"}) {
!CHECK: %[[ARG1_DECL:.*]]:2 = hlfir.declare %[[ARG1]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFmult_lastprivate_intEarg1"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: %[[ARG2_DECL:.*]]:2 = hlfir.declare %[[ARG2]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFmult_lastprivate_intEarg2"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: omp.parallel  {
!CHECK: omp.wsloop private(@{{.*}} %{{.*}}#0 -> %[[CLONE1:.*]], @{{.*}} %{{.*}}#0 -> %[[CLONE2:.*]], @{{.*}} %{{.*}}#0 -> %{{.*}} : !fir.ref<i32>, !fir.ref<i32>, !{{.*}}) {
!CHECK-NEXT: omp.loop_nest (%[[INDX_WS:.*]]) : {{.*}} {
!CHECK-DAG: %[[CLONE1_DECL:.*]]:2 = hlfir.declare %[[CLONE1]] {uniq_name = "_QFmult_lastprivate_intEarg1"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK-DAG: %[[CLONE2_DECL:.*]]:2 = hlfir.declare %[[CLONE2]] {uniq_name = "_QFmult_lastprivate_intEarg2"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)

! Testing last iteration check
!CHECK: %[[V:.*]] = arith.addi %[[INDX_WS]], %{{.*}} : i32
!CHECK: %[[C0:.*]] = arith.constant 0 : i32
!CHECK: %[[T1:.*]] = arith.cmpi slt, %{{.*}}, %[[C0]] : i32
!CHECK: %[[T2:.*]] = arith.cmpi slt, %[[V]], %{{.*}} : i32
!CHECK: %[[T3:.*]] = arith.cmpi sgt, %[[V]], %{{.*}} : i32
!CHECK: %[[IV_CMP:.*]] = arith.select %[[T1]], %[[T2]], %[[T3]] : i1
!CHECK: fir.if %[[IV_CMP]] {
!CHECK: hlfir.assign %[[V]] to %{{.*}} : i32, !fir.ref<i32>
! Testing lastprivate val update
!CHECK-DAG: %[[CLONE_LD1:.*]] = fir.load %[[CLONE1_DECL]]#0 : !fir.ref<i32>
!CHECK-DAG: hlfir.assign %[[CLONE_LD1]] to %[[ARG1_DECL]]#0 : i32, !fir.ref<i32>
!CHECK-DAG: %[[CLONE_LD2:.*]] = fir.load %[[CLONE2_DECL]]#0 : !fir.ref<i32>
!CHECK-DAG: hlfir.assign %[[CLONE_LD2]] to %[[ARG2_DECL]]#0 : i32, !fir.ref<i32>
!CHECK: }
!CHECK: omp.yield
!CHECK: }
!CHECK: }

subroutine mult_lastprivate_int(arg1, arg2)
        integer :: arg1, arg2
!$OMP PARALLEL 
!$OMP DO LASTPRIVATE(arg1) LASTPRIVATE(arg2)
do n = 1, 5
        arg1 = 2
        arg2 = 3
        print *, arg1, arg2
end do
!$OMP END DO
!$OMP END PARALLEL
print *, arg1, arg2
end subroutine

!CHECK: func.func @_QPmult_lastprivate_int2(%[[ARG1:.*]]: !fir.ref<i32> {fir.bindc_name = "arg1"}, %[[ARG2:.*]]: !fir.ref<i32> {fir.bindc_name = "arg2"}) {
!CHECK: %[[ARG1_DECL:.*]]:2 = hlfir.declare %[[ARG1]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFmult_lastprivate_int2Earg1"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: %[[ARG2_DECL:.*]]:2 = hlfir.declare %[[ARG2]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFmult_lastprivate_int2Earg2"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: omp.parallel  {
!CHECK: omp.wsloop private(@{{.*}} %{{.*}}#0 -> %[[CLONE1:.*]], @{{.*}} %{{.*}}#0 -> %[[CLONE2:.*]], @{{.*}} %{{.*}}#0 -> %{{.*}} : !fir.ref<i32>, !fir.ref<i32>, !{{.*}}) {
!CHECK-NEXT: omp.loop_nest (%[[INDX_WS:.*]]) : {{.*}} {
!CHECK-DAG: %[[CLONE1_DECL:.*]]:2 = hlfir.declare %[[CLONE1]] {uniq_name = "_QFmult_lastprivate_int2Earg1"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK-DAG: %[[CLONE2_DECL:.*]]:2 = hlfir.declare %[[CLONE2]] {uniq_name = "_QFmult_lastprivate_int2Earg2"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)

!Testing last iteration check
!CHECK: %[[V:.*]] = arith.addi %[[INDX_WS]], %{{.*}} : i32
!CHECK: %[[C0:.*]] = arith.constant 0 : i32
!CHECK: %[[T1:.*]] = arith.cmpi slt, %{{.*}}, %[[C0]] : i32
!CHECK: %[[T2:.*]] = arith.cmpi slt, %[[V]], %{{.*}} : i32
!CHECK: %[[T3:.*]] = arith.cmpi sgt, %[[V]], %{{.*}} : i32
!CHECK: %[[IV_CMP:.*]] = arith.select %[[T1]], %[[T2]], %[[T3]] : i1
!CHECK: fir.if %[[IV_CMP]] {
!CHECK: hlfir.assign %[[V]] to %{{.*}} : i32, !fir.ref<i32>
!Testing lastprivate val update
!CHECK-DAG: %[[CLONE_LD2:.*]] = fir.load %[[CLONE2_DECL]]#0 : !fir.ref<i32>
!CHECK-DAG: hlfir.assign %[[CLONE_LD2]] to %[[ARG2_DECL]]#0 : i32, !fir.ref<i32>
!CHECK-DAG: %[[CLONE_LD1:.*]] = fir.load %[[CLONE1_DECL]]#0 : !fir.ref<i32>
!CHECK-DAG: hlfir.assign %[[CLONE_LD1]] to %[[ARG1_DECL]]#0 : i32, !fir.ref<i32>
!CHECK: }
!CHECK: omp.yield
!CHECK: }
!CHECK: }

subroutine mult_lastprivate_int2(arg1, arg2)
        integer :: arg1, arg2
!$OMP PARALLEL 
!$OMP DO LASTPRIVATE(arg1, arg2)
do n = 1, 5
        arg1 = 2
        arg2 = 3
        print *, arg1, arg2
end do
!$OMP END DO
!$OMP END PARALLEL
print *, arg1, arg2
end subroutine

!CHECK: func.func @_QPfirstpriv_lastpriv_int(%[[ARG1:.*]]: !fir.ref<i32> {fir.bindc_name = "arg1"}, %[[ARG2:.*]]: !fir.ref<i32> {fir.bindc_name = "arg2"}) {
!CHECK:    %[[ARG1_DECL:.*]]:2 = hlfir.declare %[[ARG1]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFfirstpriv_lastpriv_intEarg1"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK:    %[[ARG2_DECL:.*]]:2 = hlfir.declare %[[ARG2]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFfirstpriv_lastpriv_intEarg2"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: omp.parallel  {
! Firstprivate update
!CHECK-NOT: omp.barrier
!CHECK: omp.wsloop private(@{{.*}} %{{.*}}#0 -> %[[CLONE1:.*]], @{{.*}} %{{.*}}#0 -> %[[CLONE2:.*]], @{{.*}} %{{.*}}#0 -> %{{.*}} : !fir.ref<i32>, !fir.ref<i32>, !{{.*}}) {
!CHECK-NEXT: omp.loop_nest (%[[INDX_WS:.*]]) : {{.*}} {
!CHECK: %[[CLONE1_DECL:.*]]:2 = hlfir.declare %[[CLONE1]] {uniq_name = "_QFfirstpriv_lastpriv_intEarg1"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: %[[CLONE2_DECL:.*]]:2 = hlfir.declare %[[CLONE2]] {uniq_name = "_QFfirstpriv_lastpriv_intEarg2"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)

! Testing last iteration check
!CHECK: %[[V:.*]] = arith.addi %[[INDX_WS]], %{{.*}} : i32
!CHECK: %[[C0:.*]] = arith.constant 0 : i32
!CHECK: %[[T1:.*]] = arith.cmpi slt, %{{.*}}, %[[C0]] : i32
!CHECK: %[[T2:.*]] = arith.cmpi slt, %[[V]], %{{.*}} : i32
!CHECK: %[[T3:.*]] = arith.cmpi sgt, %[[V]], %{{.*}} : i32
!CHECK: %[[IV_CMP:.*]] = arith.select %[[T1]], %[[T2]], %[[T3]] : i1
!CHECK: fir.if %[[IV_CMP]] {
!CHECK: hlfir.assign %[[V]] to %{{.*}} : i32, !fir.ref<i32>
! Testing lastprivate val update
!CHECK-NEXT: %[[CLONE_LD:.*]] = fir.load %[[CLONE2_DECL]]#0 : !fir.ref<i32>
!CHECK-NEXT: hlfir.assign %[[CLONE_LD]] to %[[ARG2_DECL]]#0 : i32, !fir.ref<i32>
!CHECK-NEXT: }
!CHECK-NEXT: omp.yield
!CHECK-NEXT: }
!CHECK-NEXT: }

subroutine firstpriv_lastpriv_int(arg1, arg2)
        integer :: arg1, arg2
!$OMP PARALLEL 
!$OMP DO FIRSTPRIVATE(arg1) LASTPRIVATE(arg2)
do n = 1, 5
        arg1 = 2
        arg2 = 3
        print *, arg1, arg2
end do
!$OMP END DO
!$OMP END PARALLEL
print *, arg1, arg2
end subroutine

!CHECK: func.func @_QPfirstpriv_lastpriv_int2(%[[ARG1:.*]]: !fir.ref<i32> {fir.bindc_name = "arg1"}) {
!CHECK: %[[ARG1_DECL:.*]]:2 = hlfir.declare %[[ARG1]] dummy_scope %{{[0-9]+}} {uniq_name = "_QFfirstpriv_lastpriv_int2Earg1"} : (!fir.ref<i32>, !fir.dscope) -> (!fir.ref<i32>, !fir.ref<i32>)
!CHECK: omp.parallel  {

! Firstprivate update


!CHECK-NEXT: omp.barrier
!CHECK: omp.wsloop private(@{{.*}} %{{.*}}#0 -> %[[CLONE1:.*]], @{{.*}} %{{.*}}#0 -> %[[IV:.*]] : !fir.ref<i32>, !fir.ref<i32>) {
!CHECK-NEXT: omp.loop_nest (%[[INDX_WS:.*]]) : {{.*}} {
!CHECK: %[[CLONE1_DECL:.*]]:2 = hlfir.declare %[[CLONE1]] {uniq_name = "_QFfirstpriv_lastpriv_int2Earg1"} : (!fir.ref<i32>) -> (!fir.ref<i32>, !fir.ref<i32>)

!CHECK-NEXT: hlfir.declare %[[IV]]
! Testing last iteration check
!CHECK: %[[V:.*]] = arith.addi %[[INDX_WS]], %{{.*}} : i32
!CHECK: %[[C0:.*]] = arith.constant 0 : i32
!CHECK: %[[T1:.*]] = arith.cmpi slt, %{{.*}}, %[[C0]] : i32
!CHECK: %[[T2:.*]] = arith.cmpi slt, %[[V]], %{{.*}} : i32
!CHECK: %[[T3:.*]] = arith.cmpi sgt, %[[V]], %{{.*}} : i32
!CHECK: %[[IV_CMP:.*]] = arith.select %[[T1]], %[[T2]], %[[T3]] : i1
!CHECK: fir.if %[[IV_CMP]] {
!CHECK: hlfir.assign %[[V]] to %{{.*}} : i32, !fir.ref<i32>
! Testing lastprivate val update
!CHECK-NEXT: %[[CLONE_LD:.*]] = fir.load %[[CLONE1_DECL]]#0 : !fir.ref<i32>
!CHECK-NEXT: hlfir.assign %[[CLONE_LD]] to %[[ARG1_DECL]]#0 : i32, !fir.ref<i32>
!CHECK-NEXT: }
!CHECK-NEXT: omp.yield
!CHECK-NEXT: }
!CHECK-NEXT: }

subroutine firstpriv_lastpriv_int2(arg1)
        integer :: arg1
!$OMP PARALLEL 
!$OMP DO FIRSTPRIVATE(arg1) LASTPRIVATE(arg1)
do n = 1, 5
        arg1 = 2
        print *, arg1
end do
!$OMP END DO
!$OMP END PARALLEL
print *, arg1
end subroutine
