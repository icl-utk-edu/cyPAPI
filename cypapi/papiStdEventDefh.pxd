cdef extern from "papiStdEventDefs.h":
    # PAPI masks
    cdef int _PAPI_PRESET_MASK "PAPI_PRESET_MASK"
    cdef int _PAPI_NATIVE_MASK "PAPI_NATIVE_MASK"
    # PAPI presets
    cdef int _PAPI_L1_DCM  "PAPI_L1_DCM"   # Level 1 data cache misses
    cdef int _PAPI_L1_ICM  "PAPI_L1_ICM"   # Level 1 instruction cache misses
    cdef int _PAPI_L2_DCM  "PAPI_L2_DCM"   # Level 2 data cache misses
    cdef int _PAPI_L2_ICM  "PAPI_L2_ICM"   # Level 2 instruction cache misses
    cdef int _PAPI_L3_DCM  "PAPI_L3_DCM"   # Level 3 data cache misses
    cdef int _PAPI_L3_ICM  "PAPI_L3_ICM"   # Level 3 instruction cache misses
    cdef int _PAPI_L1_TCM  "PAPI_L1_TCM"   # Level 1 total cache misses
    cdef int _PAPI_L2_TCM  "PAPI_L2_TCM"   # Level 2 total cache misses
    cdef int _PAPI_L3_TCM  "PAPI_L3_TCM"   # Level 3 total cache misses
    cdef int _PAPI_CA_SNP  "PAPI_CA_SNP"   # Snoops
    cdef int _PAPI_CA_SHR  "PAPI_CA_SHR"   # Request for shared cache line (SMP)
    cdef int _PAPI_CA_CLN  "PAPI_CA_CLN"   # Request for clean cache line (SMP)
    cdef int _PAPI_CA_INV  "PAPI_CA_INV"   # Request for cache line Invalidation (SMP)
    cdef int _PAPI_CA_ITV  "PAPI_CA_ITV"   # Request for cache line Intervention (SMP)
    cdef int _PAPI_L3_LDM  "PAPI_L3_LDM"   # Level 3 load misses
    cdef int _PAPI_L3_STM  "PAPI_L3_STM"   # Level 3 store misses
    cdef int _PAPI_BRU_IDL "PAPI_BRU_IDL"  # Cycles branch units are idle
    cdef int _PAPI_FXU_IDL "PAPI_FXU_IDL"  # Cycles integer units are idle
    cdef int _PAPI_FPU_IDL "PAPI_FPU_IDL"  # Cycles floating point units are idle
    cdef int _PAPI_LSU_IDL "PAPI_LSU_IDL"  # Cycles load/store units are idle
    cdef int _PAPI_TLB_DM  "PAPI_TLB_DM"   # Data translation lookaside buffer misses
    cdef int _PAPI_TLB_IM  "PAPI_TLB_IM"   # Instr translation lookaside buffer misses
    cdef int _PAPI_TLB_TL  "PAPI_TLB_TL"   # Total translation lookaside buffer misses
    cdef int _PAPI_L1_LDM  "PAPI_L1_LDM"   # Level 1 load misses
    cdef int _PAPI_L1_STM  "PAPI_L1_STM"   # Level 1 store misses
    cdef int _PAPI_L2_LDM  "PAPI_L2_LDM"   # Level 2 load misses
    cdef int _PAPI_L2_STM  "PAPI_L2_STM"   # Level 2 store misses
    cdef int _PAPI_BTAC_M  "PAPI_BTAC_M"   # BTAC miss
    cdef int _PAPI_PRF_DM  "PAPI_PRF_DM"   # Prefetch data instruction caused a missg
    cdef int _PAPI_L3_DCH  "PAPI_L3_DCH"   # Level 3 Data Cache Hit
    cdef int _PAPI_TLB_SD  "PAPI_TLB_SD"   # Xlation lookaside buffer shootdowns (SMP)g
    cdef int _PAPI_CSR_FAL "PAPI_CSR_FAL"  # Failed store conditional instructionsg
    cdef int _PAPI_CSR_SUC "PAPI_CSR_SUC"  # Successful store conditional instructionsg
    cdef int _PAPI_CSR_TOT "PAPI_CSR_TOT"  # Total store conditional instructionsg
    cdef int _PAPI_MEM_SCY "PAPI_MEM_SCY"  # Cycles Stalled Waiting for Memory Accessg
    cdef int _PAPI_MEM_RCY "PAPI_MEM_RCY"  # Cycles Stalled Waiting for Memory Readg
    cdef int _PAPI_MEM_WCY "PAPI_MEM_WCY"  # Cycles Stalled Waiting for Memory Writeg
    cdef int _PAPI_STL_ICY "PAPI_STL_ICY"  # Cycles with No Instruction Issueg
    cdef int _PAPI_FUL_ICY "PAPI_FUL_ICY"  # Cycles with Maximum Instruction Issueg
    cdef int _PAPI_STL_CCY "PAPI_STL_CCY"  # Cycles with No Instruction Completiong
    cdef int _PAPI_FUL_CCY "PAPI_FUL_CCY"  # Cycles with Maximum Instruction Completiong
    cdef int _PAPI_HW_INT  "PAPI_HW_INT"   # Hardware interruptsg
    cdef int _PAPI_BR_UCN  "PAPI_BR_UCN"   # Unconditional branch instructions executedg
    cdef int _PAPI_BR_CN   "PAPI_BR_CN"    # Conditional branch instructions executedg
    cdef int _PAPI_BR_TKN  "PAPI_BR_TKN"   # Conditional branch instructions takeng
    cdef int _PAPI_BR_NTK  "PAPI_BR_NTK"   # Conditional branch instructions not takeng
    cdef int _PAPI_BR_MSP  "PAPI_BR_MSP"   # Conditional branch instructions mispredg
    cdef int _PAPI_BR_PRC  "PAPI_BR_PRC"   # Conditional branch instructions corr. predg
    cdef int _PAPI_FMA_INS "PAPI_FMA_INS"  # FMA instructions completedg
    cdef int _PAPI_TOT_IIS "PAPI_TOT_IIS"  # Total instructions issuedg
    cdef int _PAPI_TOT_INS "PAPI_TOT_INS"  # Total instructions executed
    cdef int _PAPI_INT_INS "PAPI_INT_INS"  # Integer instructions executed
    cdef int _PAPI_FP_INS  "PAPI_FP_INS"   # Floating point instructions executedg
    cdef int _PAPI_LD_INS  "PAPI_LD_INS"   # Load instructions executedg
    cdef int _PAPI_SR_INS  "PAPI_SR_INS"   # Store instructions executedg
    cdef int _PAPI_BR_INS  "PAPI_BR_INS"   # Total branch instructions executedg
    cdef int _PAPI_VEC_INS "PAPI_VEC_INS"  # Vector#SIMD instructions executed (could include integer)g
    cdef int _PAPI_RES_STL "PAPI_RES_STL"  # Cycles processor is stalled on resourceg
    cdef int _PAPI_FP_STAL "PAPI_FP_STAL"  # Cycles any FP units are stalledg
    cdef int _PAPI_TOT_CYC "PAPI_TOT_CYC"  # Total cycles executedg
    cdef int _PAPI_LST_INS "PAPI_LST_INS"  # Total load#store inst. executedg
    cdef int _PAPI_SYC_INS "PAPI_SYC_INS"  # Sync. inst. executedg
    cdef int _PAPI_L1_DCH  "PAPI_L1_DCH"   # L1 D Cache Hitg
    cdef int _PAPI_L2_DCH  "PAPI_L2_DCH"   # L2 D Cache Hitg
    cdef int _PAPI_L1_DCA  "PAPI_L1_DCA"   # L1 D Cache Accessg
    cdef int _PAPI_L2_DCA  "PAPI_L2_DCA"   # L2 D Cache Accessg
    cdef int _PAPI_L3_DCA  "PAPI_L3_DCA"   # L3 D Cache Accessg
    cdef int _PAPI_L1_DCR  "PAPI_L1_DCR"   # L1 D Cache Readg
    cdef int _PAPI_L2_DCR  "PAPI_L2_DCR"   # L2 D Cache Readg
    cdef int _PAPI_L3_DCR  "PAPI_L3_DCR"   # L3 D Cache Readg
    cdef int _PAPI_L1_DCW  "PAPI_L1_DCW"   # L1 D Cache Writeg
    cdef int _PAPI_L2_DCW  "PAPI_L2_DCW"   # L2 D Cache Writeg
    cdef int _PAPI_L3_DCW  "PAPI_L3_DCW"   # L3 D Cache Writeg
    cdef int _PAPI_L1_ICH  "PAPI_L1_ICH"   # L1 instruction cache hitsg
    cdef int _PAPI_L2_ICH  "PAPI_L2_ICH"   # L2 instruction cache hitsg
    cdef int _PAPI_L3_ICH  "PAPI_L3_ICH"   # L3 instruction cache hitsg
    cdef int _PAPI_L1_ICA  "PAPI_L1_ICA"   # L1 instruction cache accessesg
    cdef int _PAPI_L2_ICA  "PAPI_L2_ICA"   # L2 instruction cache accessesg
    cdef int _PAPI_L3_ICA  "PAPI_L3_ICA"   # L3 instruction cache accessesg
    cdef int _PAPI_L1_ICR  "PAPI_L1_ICR"   # L1 instruction cache readsg
    cdef int _PAPI_L2_ICR  "PAPI_L2_ICR"   # L2 instruction cache readsg
    cdef int _PAPI_L3_ICR  "PAPI_L3_ICR"   # L3 instruction cache readsg
    cdef int _PAPI_L1_ICW  "PAPI_L1_ICW"   # L1 instruction cache writesg
    cdef int _PAPI_L2_ICW  "PAPI_L2_ICW"   # L2 instruction cache writesg
    cdef int _PAPI_L3_ICW  "PAPI_L3_ICW"   # L3 instruction cache writesg
    cdef int _PAPI_L1_TCH  "PAPI_L1_TCH"   # L1 total cache hitsg
    cdef int _PAPI_L2_TCH  "PAPI_L2_TCH"   # L2 total cache hitsg
    cdef int _PAPI_L3_TCH  "PAPI_L3_TCH"   # L3 total cache hitsg
    cdef int _PAPI_L1_TCA  "PAPI_L1_TCA"   # L1 total cache accessesg
    cdef int _PAPI_L2_TCA  "PAPI_L2_TCA"   # L2 total cache accessesg
    cdef int _PAPI_L3_TCA  "PAPI_L3_TCA"   # L3 total cache accessesg
    cdef int _PAPI_L1_TCR  "PAPI_L1_TCR"   # L1 total cache readsg
    cdef int _PAPI_L2_TCR  "PAPI_L2_TCR"   # L2 total cache readsg
    cdef int _PAPI_L3_TCR  "PAPI_L3_TCR"   # L3 total cache readsg
    cdef int _PAPI_L1_TCW  "PAPI_L1_TCW"   # L1 total cache writesg
    cdef int _PAPI_L2_TCW  "PAPI_L2_TCW"   # L2 total cache writesg
    cdef int _PAPI_L3_TCW  "PAPI_L3_TCW"   # L3 total cache writesg
    cdef int _PAPI_FML_INS "PAPI_FML_INS"  # FM insg
    cdef int _PAPI_FAD_INS "PAPI_FAD_INS"  # FA insg
    cdef int _PAPI_FDV_INS "PAPI_FDV_INS"  # FD insg
    cdef int _PAPI_FSQ_INS "PAPI_FSQ_INS"  # FSq insg
    cdef int _PAPI_FNV_INS "PAPI_FNV_INS"  # Finv insg
    cdef int _PAPI_FP_OPS  "PAPI_FP_OPS"   # Floating point operations executedg
    cdef int _PAPI_SP_OPS  "PAPI_SP_OPS"   # Floating point operations executed; optimized to count scaled single precision vector operationsg
    cdef int _PAPI_DP_OPS  "PAPI_DP_OPS"   # Floating point operations executed; optimized to count scaled double precision vector operationsg
    cdef int _PAPI_VEC_SP  "PAPI_VEC_SP"   # Single precision vector#SIMD instructionsg
    cdef int _PAPI_VEC_DP  "PAPI_VEC_DP"   # Double precision vector#SIMD instructionsg
    cdef int _PAPI_REF_CYC "PAPI_REF_CYC"  # Reference clock cyclesg
