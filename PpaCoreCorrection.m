% For this script, the CobraToolbox (version 2.32.0) was used
load PpaCore.mat

PpaCore2 = PpaCore;

%% Location of the biosynthesis of Asp, Glu, and Gln is not known. Deffinition of the biosynthetic reactions in both compartments is included.
% Synthesis of Glu_L and Gln_L in the mitochondria
PpaCore2 = addReaction(PpaCore2,'R_GLUDyi_mit','M_h_m + M_nh4_c + M_akg_m + M_nadph_m -> M_h2o_m + M_glu_L_m + M_nadp_m');
PpaCore2 = addReaction(PpaCore2,'R_GLNS_mit','M_nh4_c + M_glu_L_m + M_atp_m -> M_h_m + M_pi_m + M_gln_L_m + M_adp_m');
PpaCore2 = addReaction(PpaCore2,'R_Glu_tm','M_glu_L_m -> M_glu_L_c');
PpaCore2 = addReaction(PpaCore2,'R_Gln_tm','M_gln_L_m -> M_gln_L_c');

% Synthesis of Asn_L in the mitochondria
PpaCore2 = addReaction(PpaCore2,'R_ASNS1_mit','M_h2o_m + M_gln_L_m + M_atp_m + M_asp_L_m -> M_ppi_m + M_h_m + M_glu_L_m + M_amp_m + M_asn_L_m');
PpaCore2 = addReaction(PpaCore2,'R_PPAm','M_h2o_m + M_ppi_m	-> M_h_m + 2 M_pi_m');
PpaCore2 = addReaction(PpaCore2,'R_ADK1m','M_atp_m + M_amp_m <=> 2 M_adp_m');
PpaCore2 = addReaction(PpaCore2,'R_Asn_tm','M_asn_L_m -> M_asn_L_c');

%% Model compression has some contradictions with reported data on localization of the synthesis of some amino acids.
% Ala biosyntesis uses pyruvate from the mitochondria
PpaCore2 = changeRxnMets(PpaCore2, {'M_akg_c', 'M_glu_L_c', 'M_pyr_c'}, {'M_akg_m', 'M_glu_L_m', 'M_pyr_m'}, 'R_ALATA_L');

% Biosynthesis of Lys uses aKG from the mitochondria and acetyl-CoA from the
% cytosol. As cytosolic acetyl-CoA synthesis is not in the model, the
% reaction ACS is also lumped to the new reaction: 
% ACS ('M_ac_c + M_atp_c + M_coa_c -> M_accoa_c + M_amp_c + M_ppi_c').
PpaCore2 = addReaction(PpaCore2,'R_HICITDm*R_OXAGm*R_2OXOADPTm*R_HACNHm*R_HCITSm*R_MCITDm*lumped', '1 M_h2o_m + 1 M_akg_m + M_nad_m + 1 M_ac_c + M_atp_c -> 1 M_h_m + 1 M_co2_m + M_nadh_m + 1 M_2oxoadp_c + 1 M_ppi_c + 1 M_amp_c');

% Reactions R_ALACPYRL*R_3H3M2OPR*R_3H3M2OPS*R_DHAD2m*R_2OBUTtm*R_3MOPtm*R_ILETA*lumped
% and R_PDHa1 are lumped as mitochondrial pyruvate is the actual precursor of Ile biosynthesis.
PpaCore2 = addReaction(PpaCore2,'R_ALACPYRL*R_3H3M2OPR*R_3H3M2OPS*R_DHAD2m*R_2OBUTtm*R_3MOPtm*R_ILETA*lumped','2 M_h_m + 1 M_glu_L_c + 1 M_nadph_m + 1 M_2obut_c + M_pyr_m -> 1 M_h2o_m + 1 M_akg_c + 1 M_nadp_m + 1 M_ile_L_c + 1 M_co2_m');


%% The non-oxidative Pentose Phosphate Pathway was modeled using the stoichiometry 
% reported by Kleijn et al. 2005 (10.1111/j.1742-4658.2005.04907.x)

PpaCore2 = addReaction(PpaCore2,'R_TKT1','M_ru5p_D_c <=> E2 + M_g3p_c');
PpaCore2 = addReaction(PpaCore2,'R_TKT2','M_e4p_c + E2 <=> M_f6p_c');
PpaCore2 = addReaction(PpaCore2,'R_TKT3','M_ru5p_D_c + E2 <=> M_s7p_c');
PpaCore2 = addReaction(PpaCore2,'R_TALA','M_g3p_c + E3 <=> M_f6p_c');
PpaCore2 = addReaction(PpaCore2,'R_TALA2','M_s7p_c <=> M_e4p_c + E3');
