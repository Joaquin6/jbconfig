module.exports = {
  presets: [
    [
      require('babel-preset-env'), {
        browsers: "last 2 versions"
      }
    ],
    [ require('babel-preset-react') ]
  ],
  plugins: [
    [
      require('babel-plugin-transform-runtime'), {
        polyfill: false
      }
    ],
    [ require('babel-plugin-transform-class-properties') ],
    [ require('babel-plugin-transform-object-rest-spread') ]
  ]
};