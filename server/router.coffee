module.exports = (app) ->
  app.get "*", (req, res) ->
    res.render 'index.ect', {
      url: req.url
    }
