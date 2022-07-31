function out_filename = gen_docufilename(model_name, dataSelectorLabel, param_label, uid)
% type_of_file: 1 == best fit; 2 == post sampling



out_filename = sprintf('%s_%s_%s', param_label, model_name, dataSelectorLabel);

global DEMCMCpara

if isempty(DEMCMCpara)
    out_filename = sprintf('%s_u%d_docu', out_filename, uid);
else
    out_filename = sprintf('%s_u%d_de%d', out_filename, uid,DEMCMCpara);   
end


end
