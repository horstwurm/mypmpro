require 'test_helper'

class PublicationArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publication_article = publication_articles(:one)
  end

  test "should get index" do
    get publication_articles_url
    assert_response :success
  end

  test "should get new" do
    get new_publication_article_url
    assert_response :success
  end

  test "should create publication_article" do
    assert_difference('PublicationArticle.count') do
      post publication_articles_url, params: { publication_article: { active: @publication_article.active, article: @publication_article.article, publication: @publication_article.publication, sequence: @publication_article.sequence, status: @publication_article.status } }
    end

    assert_redirected_to publication_article_url(PublicationArticle.last)
  end

  test "should show publication_article" do
    get publication_article_url(@publication_article)
    assert_response :success
  end

  test "should get edit" do
    get edit_publication_article_url(@publication_article)
    assert_response :success
  end

  test "should update publication_article" do
    patch publication_article_url(@publication_article), params: { publication_article: { active: @publication_article.active, article: @publication_article.article, publication: @publication_article.publication, sequence: @publication_article.sequence, status: @publication_article.status } }
    assert_redirected_to publication_article_url(@publication_article)
  end

  test "should destroy publication_article" do
    assert_difference('PublicationArticle.count', -1) do
      delete publication_article_url(@publication_article)
    end

    assert_redirected_to publication_articles_url
  end
end
