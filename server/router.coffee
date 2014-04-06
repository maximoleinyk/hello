module.exports = (app) ->
  app.get "*", (req, res) ->
    res.render (if process.env.NODE_ENV is 'production' then 'index.ect' else 'layout.ect'), {
      url: req.url
    }
