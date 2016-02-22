$(document).ready(function()
{
    $(".nano").nanoScroller({ alwaysVisible: true });
    myNewGirl.chatter.createMessage();
    myNewGirl.app.validateReferral();
    myNewGirl.app.validateDiscountCode();
    myNewGirl.app.resizeCover();
    myNewGirl.app.resizeGallery();
    myNewGirl.app.uploadImage();
    myNewGirl.app.uploadImages();
    myNewGirl.app.uploadImageTriggers();
    myNewGirl.app.deleteImage();
    myNewGirl.app.createCard();
    myNewGirl.app.deleteCard();
    myNewGirl.app.previewImage();
    myNewGirl.app.deleteFavourite();
    myNewGirl.app.createFavourite();
});