function simtb_GUI_format_paramhelp(P)

[PARAMETER_HELP, DESC, DTYPE, EXAMPLE, LABEL] = simtb_params(P);

IconType = 'help';

Message = {['DESCRIPTION:  ' remove_tabs(DESC)], '', ['DATA TYPE:  ' remove_tabs(DTYPE)], '', ['EXAMPLE:  ' remove_tabs(EXAMPLE)]};

h = msgbox(Message,['PARAMETER: ' P], IconType);


function S = remove_tabs(S)
S = sprintf(S);
tabs = regexp(S, ['\t']);
S(tabs) = '';
