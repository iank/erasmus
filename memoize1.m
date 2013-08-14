% Adapted from http://blogs.mathworks.com/loren/2006/02/08/use-nested-functions-to-memoize-costly-functions/

function f = memoize1(F)
in = zeros(500,500);
out = [0 0 0 0];
f = @inner;
    function ret = inner(im, x, y, n, epsilon)
%        ind = find(ismember(in, [x y], 'rows'));
        ind = in(x,y);
        if ind == 0
            ret = F(im, x, y, n, epsilon);
            nextind = size(out,1)+1;
            in(x,y) = nextind;
            out(nextind,:) = ret;
        else
            ret = out(ind,:)';
        end
    end
end
