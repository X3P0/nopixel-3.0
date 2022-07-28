RegisterUICallback("np-ui:getArticles", function(data, cb)
    local article_type_id = data.type_id

    local success, message = RPC.execute("phone:getArticles", article_type_id)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:getMusicCharts", function(data, cb)
  local success, message = RPC.execute("phone:getMusicCharts")
  cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:getArticleContent", function(data, cb)
    local article_id = data.article.id

    local success, message = RPC.execute("phone:getArticleContent", article_id)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:editArticle", function(data, cb)
    local article_id, article_title, article_content, article_images = data.article.id, data.article.title, data.article.content, data.article.images
    if not article_images then article_images = {} end
    local success, message = RPC.execute("phone:editArticle", article_id, article_content, article_title, article_images)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:createArticle", function(data, cb)
    local character_id, article_title, article_content, article_images = data.character.id, data.article.title, data.article.content, data.article.images
    if not article_images then article_images = {} end
    
    --draft type id is 2 here
    local success, message = RPC.execute("phone:createArticle", character_id, article_content, article_title, 2, article_images)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:deleteArticle", function(data, cb)
    local character_id, article_id = data.character.id, data.article.id
    local success, message = RPC.execute("phone:deleteArticle", article_id, character_id)
    cb({data = {}, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:publishArticle", function(data, cb)
    local article_id = data.article.id
    local success, message = RPC.execute("phone:updateArticleState", article_id, 1)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:unpublishArticle", function(data, cb)
    local article_id = data.article.id
    local success, message = RPC.execute("phone:updateArticleState", article_id, 2)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)

RegisterUICallback("np-ui:startEditArticle", function(data, cb)
    local success, message = RPC.execute("phone:articleUnlock", data)
    cb({data = message, meta = {ok = success, message = (not success and message or "done")}})
end)
