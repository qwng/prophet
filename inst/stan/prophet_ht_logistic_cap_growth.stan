data {
  int T;                                // Sample size
  int N;                                // Number of Time-series
  int<lower=1> K;                       // Number of seasonal vectors
  vector[T] t;                            // Day
  matrix[T, N] y;                            // Time-series
  int S;                                // Number of changepoints
  matrix[T, S] A;                   // Split indicators
  real t_change[S];                 // Index of changepoints
  matrix[T,K] X;                    // season vectors
  real<lower=0> sigma;              // scale on seasonality prior
  real<lower=0> tau;                  // scale on changepoints prior
  real kappa_int;                     // mean for capacities intercept
  real kappa_slope;                   // mean for capacities slope
}

parameters {
  vector[N] k;                           // Base growth rate
  vector[N] m;                            // offset
  vector[N] cap_int;                          // Capacities intercept
  vector[N] cap_slope;                       // Capacities slope
  matrix[S, N] delta;                       // Rate adjustments
  real<lower=0> sigma_obs;               // Observation noise (incl. seasonal variation)
  matrix[K, N] beta;                    // seasonal vector
}

transformed parameters {
  matrix[S, N] gamma;                  // adjusted offsets, for piecewise continuity
  row_vector[N] k_s[S + 1];            // actual rate in each segment
  vector[N] m_pr;
  
  // Compute the rate in each segment
  k_s[1] = to_row_vector(k);
  for (i in 1:S) {
    k_s[i + 1] = k_s[i] + delta[i, ];
  }
  
  
  // Piecewise offsets
  m_pr = m; // The offset in the previous segment
  for (i in 1:S) {
    gamma[i, ] = to_row_vector((t_change[i] - m_pr) .* to_vector((1 - k_s[i] ./ k_s[i + 1])));
    m_pr = m_pr + to_vector(gamma[i, ]);  // update for the next segment
  }
}

model {
  //priors
  to_vector(k) ~ normal(0, 5);
  to_vector(m) ~ normal(0, 5);
  to_vector(delta) ~ double_exponential(0, tau);
  sigma_obs ~ normal(0, 0.1);
  to_vector(beta) ~ normal(0, sigma);
  to_vector(cap_int) ~ normal(kappa_int, 5);
  to_vector(cap_slope) ~ normal(cap_slope, 5);
  
  // Likelihood
  {
    matrix[T, N] mu_y;               
    for (n in 1:N) {
      mu_y[, n] = (cap_int[n] + cap_slope[n] * t) ./ (1 + exp(-(k[n] + A * delta[,n]) .* (t - (m[n] + A * gamma[,n])))) + X * beta[,n];
    }
    to_vector(y) ~ normal(to_vector(mu_y), sigma_obs);
  }
}
