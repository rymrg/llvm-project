; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 5
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -passes=instcombine < %s | FileCheck %s
; --------------------------------------------------------------------
; llvm.amdgcn.fmed3
; --------------------------------------------------------------------

declare float @llvm.amdgcn.fmed3.f32(float, float, float) #0

define float @fmed3_f32(float %x, float %y, float %z) #1 {
; CHECK-LABEL: define float @fmed3_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]], float [[Z:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float [[Y]], float [[Z]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float %y, float %z)
  ret float %med3
}

define float @fmed3_canonicalize_x_c0_c1_f32(float %x) #1 {
; CHECK-LABEL: define float @fmed3_canonicalize_x_c0_c1_f32(
; CHECK-SAME: float [[X:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float 0.000000e+00, float 1.000000e+00)
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float 0.0, float 1.0)
  ret float %med3
}

define float @fmed3_canonicalize_c0_x_c1_f32(float %x) #1 {
; CHECK-LABEL: define float @fmed3_canonicalize_c0_x_c1_f32(
; CHECK-SAME: float [[X:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float 0.000000e+00, float 1.000000e+00)
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0.0, float %x, float 1.0)
  ret float %med3
}

define float @fmed3_canonicalize_c0_c1_x_f32(float %x) #1 {
; CHECK-LABEL: define float @fmed3_canonicalize_c0_c1_x_f32(
; CHECK-SAME: float [[X:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float 0.000000e+00, float 1.000000e+00)
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0.0, float 1.0, float %x)
  ret float %med3
}

define float @fmed3_canonicalize_x_y_c_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_canonicalize_x_y_c_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float [[Y]], float 1.000000e+00)
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float %y, float 1.0)
  ret float %med3
}

define float @fmed3_canonicalize_x_c_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_canonicalize_x_c_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float [[Y]], float 1.000000e+00)
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float 1.0, float %y)
  ret float %med3
}

define float @fmed3_canonicalize_c_x_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_canonicalize_c_x_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.amdgcn.fmed3.f32(float [[X]], float [[Y]], float 1.000000e+00)
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 1.0, float %x, float %y)
  ret float %med3
}

define float @fmed3_undef_x_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_undef_x_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.minnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float undef, float %x, float %y)
  ret float %med3
}

define float @fmed3_fmf_undef_x_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_fmf_undef_x_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call nnan float @llvm.minnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call nnan float @llvm.amdgcn.fmed3.f32(float undef, float %x, float %y)
  ret float %med3
}

define float @fmed3_x_undef_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_x_undef_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.minnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float undef, float %y)
  ret float %med3
}

define float @fmed3_x_y_undef_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_x_y_undef_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.maxnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float %y, float undef)
  ret float %med3
}

define float @fmed3_qnan0_x_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_qnan0_x_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.minnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0x7FF8000000000000, float %x, float %y)
  ret float %med3
}

define float @fmed3_x_qnan0_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_x_qnan0_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.minnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float 0x7FF8000000000000, float %y)
  ret float %med3
}

define float @fmed3_x_y_qnan0_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_x_y_qnan0_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.maxnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float %y, float 0x7FF8000000000000)
  ret float %med3
}

define float @fmed3_qnan1_x_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_qnan1_x_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[MED3:%.*]] = call float @llvm.minnum.f32(float [[X]], float [[Y]])
; CHECK-NEXT:    ret float [[MED3]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0x7FF8000100000000, float %x, float %y)
  ret float %med3
}

; This can return any of the qnans.
define float @fmed3_qnan0_qnan1_qnan2_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_qnan0_qnan1_qnan2_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 0x7FF8030000000000
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0x7FF8000100000000, float 0x7FF8002000000000, float 0x7FF8030000000000)
  ret float %med3
}

define float @fmed3_constant_src0_0_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_constant_src0_0_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 5.000000e-01
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0.5, float -1.0, float 4.0)
  ret float %med3
}

define float @fmed3_constant_src0_1_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_constant_src0_1_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 5.000000e-01
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0.5, float 4.0, float -1.0)
  ret float %med3
}

define float @fmed3_constant_src1_0_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_constant_src1_0_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 5.000000e-01
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float -1.0, float 0.5, float 4.0)
  ret float %med3
}

define float @fmed3_constant_src1_1_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_constant_src1_1_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 5.000000e-01
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 4.0, float 0.5, float -1.0)
  ret float %med3
}

define float @fmed3_constant_src2_0_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_constant_src2_0_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 5.000000e-01
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float -1.0, float 4.0, float 0.5)
  ret float %med3
}

define float @fmed3_constant_src2_1_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_constant_src2_1_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float 5.000000e-01
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 4.0, float -1.0, float 0.5)
  ret float %med3
}

define float @fmed3_x_qnan0_qnan1_f32(float %x) #1 {
; CHECK-LABEL: define float @fmed3_x_qnan0_qnan1_f32(
; CHECK-SAME: float [[X:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float [[X]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float 0x7FF8001000000000, float 0x7FF8002000000000)
  ret float %med3
}

define float @fmed3_qnan0_x_qnan1_f32(float %x) #1 {
; CHECK-LABEL: define float @fmed3_qnan0_x_qnan1_f32(
; CHECK-SAME: float [[X:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float [[X]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0x7FF8001000000000, float %x, float 0x7FF8002000000000)
  ret float %med3
}

define float @fmed3_qnan0_qnan1_x_f32(float %x) #1 {
; CHECK-LABEL: define float @fmed3_qnan0_qnan1_x_f32(
; CHECK-SAME: float [[X:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float [[X]]
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0x7FF8001000000000, float 0x7FF8002000000000, float %x)
  ret float %med3
}

define float @fmed3_nan_0_1_f32() #1 {
; CHECK-LABEL: define float @fmed3_nan_0_1_f32(
; CHECK-SAME: ) #[[ATTR1]] {
; CHECK-NEXT:    ret float 0.000000e+00
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float 0x7FF8001000000000, float 0.0, float 1.0)
  ret float %med3
}

define float @fmed3_0_nan_1_f32() #1 {
; CHECK-LABEL: define float @fmed3_0_nan_1_f32(
; CHECK-SAME: ) #[[ATTR1]] {
; CHECK-NEXT:    ret float 0.000000e+00
;
  %med = call float @llvm.amdgcn.fmed3.f32(float 0.0, float 0x7FF8001000000000, float 1.0)
  ret float %med
}

define float @fmed3_0_1_nan_f32() #1 {
; CHECK-LABEL: define float @fmed3_0_1_nan_f32(
; CHECK-SAME: ) #[[ATTR1]] {
; CHECK-NEXT:    ret float 1.000000e+00
;
  %med = call float @llvm.amdgcn.fmed3.f32(float 0.0, float 1.0, float 0x7FF8001000000000)
  ret float %med
}

define float @fmed3_undef_0_1_f32() #1 {
; CHECK-LABEL: define float @fmed3_undef_0_1_f32(
; CHECK-SAME: ) #[[ATTR1]] {
; CHECK-NEXT:    ret float 0.000000e+00
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float undef, float 0.0, float 1.0)
  ret float %med3
}

define float @fmed3_0_undef_1_f32() #1 {
; CHECK-LABEL: define float @fmed3_0_undef_1_f32(
; CHECK-SAME: ) #[[ATTR1]] {
; CHECK-NEXT:    ret float 0.000000e+00
;
  %med = call float @llvm.amdgcn.fmed3.f32(float 0.0, float undef, float 1.0)
  ret float %med
}

define float @fmed3_0_1_undef_f32() #1 {
; CHECK-LABEL: define float @fmed3_0_1_undef_f32(
; CHECK-SAME: ) #[[ATTR1]] {
; CHECK-NEXT:    ret float 1.000000e+00
;
  %med = call float @llvm.amdgcn.fmed3.f32(float 0.0, float 1.0, float undef)
  ret float %med
}

define float @fmed3_poison_x_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_poison_x_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float poison
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float poison, float %x, float %y)
  ret float %med3
}

define float @fmed3_x_poison_y_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_x_poison_y_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float poison
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float poison, float %y)
  ret float %med3
}

define float @fmed3_x_y_poison_f32(float %x, float %y) #1 {
; CHECK-LABEL: define float @fmed3_x_y_poison_f32(
; CHECK-SAME: float [[X:%.*]], float [[Y:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    ret float poison
;
  %med3 = call float @llvm.amdgcn.fmed3.f32(float %x, float %y, float poison)
  ret float %med3
}

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { nounwind }
