function Calculator()

global canT;
global curve;
global beta;
global alpha;
global FPactual;
global hypothesis;
global p0n;
global p0v;
global p0vary;
global p1;
global q0;
global q0n;
global tau0;
global tau1;

if FPactual
    FPac = FPactual;
else
    FPac = alpha;
end

for p = p0n
    if p0v
        p0 = p0v;
    else
        p0 = 1/100*p-1/100; % publishing negative results rate
    end
    if ~p0vary
        p0c = p0;
    end
    for q = q0n
        if q0
            qc = [q0; 1];
        else
            qc = [1/100*q-1/100; 1];
        end
        while sum(qc(2, :)) > 10^-4 % while the sum of the visit probabilites are larger than 10^{-4}
            if curve
                if p0v
                    canT(q, curve) = canT(q, curve) + sum(qc(2, qc(1, :) > tau1)); % Calculate the accumlated percentage of canonization
                else
                    canT(p, curve) = canT(p, curve) + sum(qc(2, qc(1, :) > tau1));
                end
            else
                canT(p, q) = canT(p, q) + sum(qc(2, qc(1, :) > tau1));
            end
            qc(:, qc(1, :) > tau1) = []; % Don't continue canonized paths 
            qc(:, qc(1, :) < tau0) = [];
            if size(qc, 2)
                newQ = zeros(2, size(qc, 2)+1);
                for i = 1:size(qc, 2)
                    if p0vary
                        p0c = (1-p0)*qc(1, i) + p0;
                    end
                    if i == 1 % this if statement only find the lowest belief rate
                        newQ(1, i) = beta*qc(1, i)/(beta*qc(1, i) + (1-alpha)*(1-qc(1, i))); % published negative, FP=alpha_no
                    end
                    if hypothesis % this if-else statement only updates all the weights (except the one with the highest belief rate)
                        newQ(2, i) = newQ(2, i) + qc(2, i)*beta*p0c/(beta*p0c+(1-beta)*p1); % hypothesis true and published negative
                    else
                        newQ(2, i) = newQ(2, i) + qc(2, i)*(1-FPac)*p0c/((1-FPac)*p0c+FPac*p1); % increase weight, FP=alpha_ac
                    end
                    if hypothesis % this if-else statement find all belief rates (except the lowest) and updates all the weights (except the one with the lowest q)
                        newQ(:, i+1) = [(1-beta)*qc(1, i)/((1-beta)*qc(1, i)+alpha*(1-qc(1, i))); qc(2, i)*(1-beta)*p1/(beta*p0c+(1-beta)*p1)]; % hyp. true, pub. pos.
                    else
                        newQ(:, i+1) = [(1-beta)*qc(1, i)/((1-beta)*qc(1, i)+alpha*(1-qc(1, i))); qc(2, i)*FPac*p1/((1-FPac)*p0c+FPac*p1)]; % published pos., both
                    end % 'newQ(2, i+1) +' is not need in this if-else due to it is the first time that value is calculated, i.e. newQ(2, i+1) = 0 before the statement
                end
                qc = newQ;
            end
        end
    end
end