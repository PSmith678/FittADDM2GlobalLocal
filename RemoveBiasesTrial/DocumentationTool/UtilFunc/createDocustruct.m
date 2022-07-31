function ret = createDocustruct()

fields = listDocufields();

ret = [];

for i=1:length(fields)
   ret = setfield(ret, fields{i}, []);
end

ret.versPointers.children = [];
ret.versPointers.parent = 0;
ret.descr.title = '';
ret.descr.parent = '';
ret.descr.curr = '';
ret.descr.future ='';

global versMajor 
global versMinor

ret.vers.minor = versMinor;
ret.vers.major = versMajor;

ret.modTimes{1} = datestr(now);

ret = addDocuFields(ret);
