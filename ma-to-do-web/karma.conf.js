const webpackConfig = require('./karma-webpack.conf.js');

module.exports = function (config) {
  config.set({
    frameworks: ['mocha', 'chai'],
    files: [
      { pattern: './src/test.ts', watched: false },
    ],
    preprocessors: {
      './src/test.ts': ['webpack'],
    },
    webpack: {
      ...webpackConfig, // Ajouter la configuration Webpack personnalisée
      module: {
        rules: [
          {
            test: /\.ts$/,
            use: 'ts-loader',
            exclude: /node_modules/,
          },
        ],
      },
      resolve: {
        extensions: ['.ts', '.js'],
      },
    },
    browsers: ['Chrome'],
    reporters: ['progress'],
    singleRun: false,
    concurrency: Infinity,
  });
};
