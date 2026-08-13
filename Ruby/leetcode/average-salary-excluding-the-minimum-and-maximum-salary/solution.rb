def average(salary)
    mn = salary[0]; mx = salary[0]; sum = 0
    salary.each { |s| sum += s; mn = s if s < mn; mx = s if s > mx }
    (sum - mn - mx).to_f / (salary.length - 2)
end
