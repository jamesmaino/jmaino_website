//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data{
    int<lower=1> N;
    int<lower=1> N_participant;
    int detection[N];
    int participant[N];
    real experience[N];
    real search_effort_h_ha[N];
    real egg_size_c[N];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters{
    real a;
    real b;
    real c;
    real<lower=0> sigma;
    vector[N_participant] obs;
}

transformed parameters {
  vector[N] lambda;
  lambda = a + b * egg_size_c + c * experience + obs[participant];     
}
// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.

model{
    vector[N] p;
    sigma ~ cauchy( 0 , 1 );
    obs ~ normal( 0 , sigma );
    c ~ normal( 0 , 10 );
    b ~ normal( 0 , 10 );
    a ~ normal( 0 , 10 );
    for ( i in 1:N ) {
        p[i] = 1 - exp(-lambda[i] * search_effort_h_ha[i]);
    }
    detection ~ binomial( 1 , p );
}
generated quantities{
    vector[N] p;
    real dev;
    dev = 0;
    for ( i in 1:N ) {
        p[i] = 1 - exp(-abs(a + b * egg_size_c[i] + c * experience[i] + obs[participant[i]]) *      search_effort_h_ha[i]);
    }
    dev = dev + (-2)*binomial_lpmf( detection | 1 , p );
}
