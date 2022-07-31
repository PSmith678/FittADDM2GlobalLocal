function out_filename = gen_demcmcoutputfile(param_label, model_name, selector_name, uid, demcmc_type)
% type_of_file: 1 == best fit; 2 == post sampling

if demcmc_type == 1
out_filename = sprintf('./DEMCMC_Outputs/%s_%s_%s_u%d_best', param_label, model_name, selector_name, uid);
end

if demcmc_type == 2
out_filename = sprintf('./DEMCMC_Outputs/%s_%s_%s_u%d_post', param_label, model_name, selector_name, uid);
end

end
