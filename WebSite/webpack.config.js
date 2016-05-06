module.exports = {
  entry: './src/main.js',
  output: {
    path: './www/js',
    filename: 'build.js'
  },
  module: {
    loaders: [
      // 使用vue-loader 加载 .vue 结尾的文件
      {
        test: /\.vue$/,
        loader: 'vue'
      },
      // 使用babel,编译ES6语法
      {
        test: /\.js$/,
        loader: 'babel?presets=es2015',
        exclude: /node_modules/
        // exclude: /node_modules|vue\/src|vue-router\/|vue-loader\/|vue-hot-reload-api\//,
      }
    ]
  }
}