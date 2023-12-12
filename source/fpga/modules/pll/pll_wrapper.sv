/*
 * This file is a part of: https://github.com/brilliantlabsAR/frame-codebase
 *
 * Authored by: Rohit Rathnam / Silicon Witchery AB (rohit@siliconwitchery.com)
 *              Raj Nakarja / Brilliant Labs Limited (raj@brilliant.xyz)
 *
 * CERN Open Hardware Licence Version 2 - Permissive
 *
 * Copyright © 2023 Brilliant Labs Limited
 */

module pll_wrapper (
    input logic clki_i,
    output logic clkop_o,
    output logic clkos_o,
    output logic clkos2_o,
    output logic clkos3_o,
    output logic clkos4_o,
    output logic clkos5_o,
    output logic lock_o
);

logic feedback_w;
assign feedback_w = clkos5_o;

PLL #(
    // Settings are generated by Radiant
    .BW_CTL_BIAS("0b1111"),
    .CLKMUX_FB("CMUX_CLKOS5"),
    .CLKOP_TRIM("0b0000"),
    .CLKOS_TRIM("0b0000"),
    .CLKOS2_TRIM("0b0000"),
    .CLKOS3_TRIM("0b0000"),
    .CLKOS4_TRIM("0b0000"),
    .CLKOS5_TRIM("0b0000"),
    .CRIPPLE("1P"),
    .CSET("8P"),
    .DELA("59"),
    .DELAY_CTRL("200PS"),
    .DELB("39"),
    .DELC("9"),
    .DELD("28"),
    .DELE("14"),
    .DELF("3"),
    .DIRECTION("DISABLED"),
    .DIV_DEL("0b0000011"),
    .DIVA("59"),
    .DIVB("39"),
    .DIVC("9"),
    .DIVD("28"),
    .DIVE("14"),
    .DIVF("3"),
    .DYN_SEL("0b000"),
    .DYN_SOURCE("STATIC"),
    .ENABLE_SYNC("DISABLED"),
    .ENCLK_CLKOP("ENABLED"),
    .ENCLK_CLKOS("ENABLED"),
    .ENCLK_CLKOS2("ENABLED"),
    .ENCLK_CLKOS3("ENABLED"),
    .ENCLK_CLKOS4("ENABLED"),
    .ENCLK_CLKOS5("ENABLED"),
    .EXTERNAL_DIVIDE_FACTOR("0"),
    .FAST_LOCK_EN("ENABLED"),
    .FBK_CUR_BLE("0b00000000"),
    .FBK_EDGE_SEL("POSITIVE"),
    .FBK_IF_TIMING_CTL("0b00"),
    .FBK_INTEGER_MODE("ENABLED"),
    .FBK_MASK("0b00000000"),
    .FBK_MMD_DIG("20"),
    .FBK_MMD_PULS_CTL("0b0001"),
    .FBK_MODE("0b00"),
    .FBK_PI_BYPASS("NOT_BYPASSED"),
    .FBK_PI_RC("0b1100"),
    .FBK_PR_CC("0b0000"),
    .FBK_PR_IC("0b1000"),
    .FLOAT_CP("DISABLED"),
    .FLOCK_CTRL("2X"),
    .FLOCK_EN("ENABLED"),
    .FLOCK_SRC_SEL("REFCLK"),
    .FORCE_FILTER("DISABLED"),
    .I_CTRL("10UA"),
    .IPI_CMP("0b1100"),
    .IPI_CMPN("0b0011"),
    .IPI_COMP_EN("DISABLED"),
    .IPP_CTRL("0b0110"),
    .IPP_SEL("0b1111"),
    .KP_VCO("0b00011"),
    .LDT_INT_LOCK_STICKY("DISABLED"),
    .LDT_LOCK("1536CYC"),
    .LDT_LOCK_SEL("UFREQ"),
    .LEGACY_ATT("DISABLED"),
    .LOAD_REG("DISABLED"),
    .OPENLOOP_EN("DISABLED"),
    .PHASE_SEL_DEL("0b000"),
    .PHASE_SEL_DEL_P1("0b000"),
    .PHIA("0"),
    .PHIB("0"),
    .PHIC("0"),
    .PHID("0"),
    .PHIE("0"),
    .PHIF("0"),
    .PLLPD_N("USED"),
    .PLLPDN_EN("DISABLED"),
    .PLLRESET_ENA("DISABLED"),
    .REF_INTEGER_MODE("ENABLED"),
    .REF_MASK("0b00000000"),
    .REF_MMD_DIG("1"),
    .REF_MMD_IN("0b00001000"),
    .REF_MMD_PULS_CTL("0b0000"),
    .REF_TIMING_CTL("0b00"),
    .REFIN_RESET("SET"),
    .RESET_LF("DISABLED"),
    .ROTATE("DISABLED"),
    .SEL_FBK("FBKCLK5"),
    .SEL_OUTA("DISABLED"),
    .SEL_OUTB("DISABLED"),
    .SEL_OUTC("DISABLED"),
    .SEL_OUTD("DISABLED"),
    .SEL_OUTE("DISABLED"),
    .SEL_OUTF("DISABLED"),
    .SLEEP("DISABLED"),
    .SSC_DITHER("DISABLED"),
    .SSC_EN_CENTER_IN("DOWN_TRIANGLE"),
    .SSC_EN_SDM("DISABLED"),
    .SSC_EN_SSC("DISABLED"),
    .SSC_F_CODE("0b000000000000000"),
    .SSC_N_CODE("0b000000000"),
    .SSC_ORDER("SDM_ORDER1"),
    .SSC_PI_BYPASS("NOT_BYPASSED"),
    .SSC_REG_WEIGHTING_SEL("0b000"),
    .SSC_SQUARE_MODE("DISABLED"),
    .SSC_STEP_IN("0b0000000"),
    .SSC_TBASE("0b000000000000"),
    .STDBY_ATT("DISABLED"),
    .TRIMOP_BYPASS_N("BYPASSED"),
    .TRIMOS_BYPASS_N("BYPASSED"),
    .TRIMOS2_BYPASS_N("BYPASSED"),
    .TRIMOS3_BYPASS_N("BYPASSED"),
    .TRIMOS4_BYPASS_N("BYPASSED"),
    .TRIMOS5_BYPASS_N("BYPASSED"),
    .V2I_1V_EN("ENABLED"),
    .V2I_KVCO_SEL("60"),
    .V2I_PP_ICTRL("0b11111"),
    .V2I_PP_RES("9K")
) pll (
    // Inputs
    .FBKCK(feedback_w),
    .PLLRESET(0),
    .REFCK(clki_i),
    
    // Outputs
    .CLKOP(clkop_o),
    .CLKOS(clkos_o),
    .CLKOS2(clkos2_o),
    .CLKOS3(clkos3_o),
    .CLKOS4(clkos4_o),
    .CLKOS5(clkos5_o),
    .LOCK(lock_o)
);

endmodule