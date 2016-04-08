/**
 create by liuchan
 note:必须在使用此TableView的ViewController中写出以下三个方法,否则无法实现下拉刷新
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 [tableview scrollViewWillBeginDragging:scrollView];
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 [tableview scrollViewDidScroll:scrollView];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
 [tableview scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
 }
*/

#import <UIKit/UIKit.h>

@protocol PullRefreshDelegate<NSObject>

@optional
-(void)onPullRefresh;
-(void)onPushLoadingMore;

@end

@interface PullRefreshTableView : UITableView<UIScrollViewDelegate> {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    UIActivityIndicatorView *moreIndicator;
    UIButton *tableFooter;
    
    BOOL isDragging;
    BOOL isLoading;
    BOOL isPullEnable;
    
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIImageView *refreshArrow;
@property (nonatomic, strong) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, strong) NSString *textPull;
@property (nonatomic, strong) NSString *textRelease;
@property (nonatomic, strong) NSString *textLoading;

@property (nonatomic) id<PullRefreshDelegate> refreshDelegate;

-(void)setPullEnable:(BOOL)isEnable;
- (void)addPullToRefreshHeader;
- (void)setupStrings;

- (void)startLoading;
- (void)stopLoading;

- (void)hideRefresh;
- (void)showRefresh;
-(void)showHeaderView;

@end
