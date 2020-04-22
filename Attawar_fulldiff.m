function dout=fulldiff(varargin)


if nargin >= 1
    fun=varargin{1}; else, error('Must provide function'), 
end

%---- Parse the input to get a variable of diff and dimension
if nargin >= 2
    two=varargin{2};
    if isnumeric(two)
        dim=two;
        var=checkvar(fun);
    else
        var=varargin{2};
        dim=1;
    end
    if nargin >= 3
        dim=varargin{3};
    end
else
    var=checkvar(fun);
    dim=1;
end

%---- Compute full derivative
if length(var)==1 && ~iscell(var)
    vars={char(var)};  %---- eg r
else
    for i=1:length(var)
        vars{i}=char(var{i});  %---- eg {r,t}
    end
end


for k=1:dim
    strfun=char(fun);
    i=1;
    prevlength=0;
    for j = 1:length(vars)
        i=1;
        var=vars{j};
        dvars{i+prevlength,1}=vars{j};
        dvars{i+prevlength,2}=['d',vars{j}];
        while true
            if i==1
                fstr=['d',var];
                fstr2=['d2',var];
            else
                fstr=['d',num2str(i),var];
                fstr2=['d',num2str(i)+1,var];
            end
            id=strfind(strfun,fstr);
            if ~isempty(id)
                dvars{(i+1)+prevlength,1}=fstr;
                dvars{(i+1)+prevlength,2}=fstr2;
                i=i+1;
            else
                break
            end
        end
        prevlength=size(dvars,1);
    end
    
    % Bug identified.  The above technic will produce duplicates which
    % results in erroneous differential; therefore, the quick fix is to
    % search for duplicates and remove them.
    n=1;
    while n < size(dvars,1) % search the elements within the column
        % id=strmatch(dvars(n,1),dvars(n+1:end,1)); % find duplicates
        % Bug 2 identified. In an attempt to find duplicates e1 was
        % erroneously identified as matching e10. Therefore, the 'exact'
        % flag has been added to strmatch to avoid this problem.
        id=strmatch(dvars(n,1),dvars(n+1:end,1),'exact'); % find duplicates
        if ~isempty(id)
            dvars(n+id,:)=[]; % eliminate entire row(s)
        end
        n=n+1;
    end % End bug fix.
    
    % Up to here we only captured x and dx, what about d2x and higher
    dvars=findhigher(fun,vars,dvars);
    dout=dvars;
    
    for i=1:size(dvars,1)
        var=sym(dvars{i,1});
        dvar=sym(dvars{i,2});
        partial_diff=diff(fun,var);
        if i==1
            full_diff=partial_diff*dvar;
        else
            full_diff=full_diff+partial_diff*dvar;
        end
    end
    
    dout=full_diff;
    
    fun=full_diff;
end

function var=checkvar(fun)

vars=findsym(fun,1);
if length(vars)==0
    error('Function must contain a variable')
else
    var=sym(vars); % could be x, y
end

function Dvars=findhigher(fun,vars,dvars)

bUseSymvar = true;  % updated to use symvar instead of findsym
%bUseSymvar = false; % original code version

Dvars=dvars;
if bUseSymvar
    allvar = symvar(fun); % outputs N-element (type "sym") variable (KB)
else
    allvar=findsym(fun); % outputs a string (type "char") variable (KB)
end

if isempty(allvar), return, end

if bUseSymvar % this is actually more compact
    for i = 1:length(allvar) % put elements into a cell (KB)
        callvar{i} = char(allvar(i)); % not known is conversion to "char" required (KB)
    end
else
    cid=strfind(allvar,',');
    
    if isempty(cid)
        % There's only one variable
        callvar={allvar};
    else
        lenc=length(cid);
        callvar=cell(lenc+1,1);
        for i=1:(lenc+1)
            if i==1
                % first one
                callvar{i}=allvar(1:(cid(i)-1));
            elseif i > lenc
                % last one
                callvar{i}=allvar(cid(i-1)+1:end);
            else
                % middle one
                callvar{i}=allvar((cid(i-1)+1):(cid(i)-1));
            end
        end
    end
end
% We now have a cell of all the symbolic variables
% Remove leading spaces

for i=1:length(callvar)
    var=callvar{i};
    lenstr=length(var);
    keep=true(1,lenstr);
    for j=1:lenstr
        if strcmp(var(j),' ');
            keep(j)=false;
        end
    end
    callvar{i}=var(keep);
end
% Look for derivatives
for i=1:length(callvar)
    var=callvar{i};
    one=var(1);
    if strcmp(one,'d')
        % Get order of derivative
        if length(var)==1
            % variable is 'd', hence not derivative
            continue
        else
            num=1;
            for j=2:length(var)
                tnum=var(j);
                if isempty(str2num(tnum));
                    % no more numbers
                    pvar=var(j:end); % potential variable match
                    k=strmatch(pvar,vars,'exact');
                    if ~isempty(k)
                        % Found a derivative of a time variable
                        % See if it is already in dvars
                        m=strmatch(var,dvars(:,1));
                        if isempty(m)
                            % It's not there must append to dvars
                            addrow=size(Dvars,1)+1;
                            Dvars{addrow,1}=var;
                            Dvars{addrow,2}=['d',num2str(num+1),vars{k}];
                        end
                    end
                else
                    num=str2num(var(2:j));
                end
            end
        end
    end
end


