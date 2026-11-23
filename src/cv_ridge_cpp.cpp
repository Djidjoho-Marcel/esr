#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace arma;

//' Validation croisee K-Fold pour Ridge (Version C++)
//' @param X Matrice des variables explicatives.
//' @param y Vecteur de la variable reponse.
//' @param lambdas Vecteur des lambdas a tester.
//' @param k Nombre de plis.
//' @return Un vecteur contenant le MSE moyen pour chaque lambda.
// [[Rcpp::export]]
arma::vec cv_ridge_cpp(const arma::mat& X, const arma::vec& y, const arma::vec& lambdas, int k) {
  int n = X.n_rows;
  int p = X.n_cols;
  int n_lambdas = lambdas.n_elem;
  vec mses(n_lambdas, fill::zeros);

  ivec plis(n);
  for (int i = 0; i < n; i++) {
    plis(i) = (i % k) + 1;
  }

  mat identity_mat = eye<mat>(p, p);

  for (int l = 0; l < n_lambdas; l++) {
    double lam = lambdas(l);
    double total_squared_error = 0.0;

    for (int j = 1; j <= k; j++) {
      int n_test = 0;
      for (int i = 0; i < n; i++) {
        if (plis(i) == j) n_test++;
      }
      int n_train = n - n_test;

      mat X_train(n_train, p);
      vec y_train(n_train);
      mat X_test(n_test, p);
      vec y_test(n_test);

      int idx_train = 0;
      int idx_test = 0;

      for (int i = 0; i < n; i++) {
        if (plis(i) == j) {
          X_test.row(idx_test) = X.row(i);
          y_test(idx_test) = y(i);
          idx_test++;
        } else {
          X_train.row(idx_train) = X.row(i);
          y_train(idx_train) = y(i);
          idx_train++;
        }
      }

      vec beta_ridge = solve(X_train.t() * X_train + lam * identity_mat, X_train.t() * y_train);
      vec preds = X_test * beta_ridge;
      total_squared_error += sum(square(y_test - preds));
    }
    mses(l) = total_squared_error / n;
  }
  return mses;
}
