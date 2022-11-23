function Message = simtb_GUI_format_paramlabel(P)

[PARAMETER_HELP, DESC, DTYPE, EXAMPLE, LABEL] = simtb_params(P);

Message = strcat (remove_tabs(LABEL));


function S = remove_tabs(S)
tabs = regexp(S, ['\t']);
S(tabs) = '';