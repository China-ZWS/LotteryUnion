#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation PullRefreshTableView

@synthesize textPull, textRelease, textLoading; // textLoading 正在刷新
@synthesize refreshHeaderView, refreshLabel;
@synthesize refreshArrow, refreshSpinner;
@synthesize refreshDelegate;

-(id)init{
    self = [super init];
    if (self != nil) {
        [self setupStrings];
        [self addPullToRefreshHeader];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupStrings];
        [self addPullToRefreshHeader];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        [self setupStrings];
        [self addPullToRefreshHeader];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupStrings];
    [self addPullToRefreshHeader];
}

-(void)setPullEnable:(BOOL)isEnable{
    isPullEnable = isEnable;
    if(isPullEnable && refreshHeaderView){
        [refreshHeaderView setHidden:NO];
    }else if(!isPullEnable && refreshHeaderView){
        [refreshHeaderView setHidden:YES];
    }
}

- (void)setupStrings{
    textPull = LocStr(@"pull_to_refresh_pull_label");
    textRelease = LocStr(@"pull_to_refresh_release_label");
    textLoading = LocStr(@"pull_to_refresh_refreshing_label");
    [self setPullEnable:YES];
}

-(void)addPullToLoadingMoreFooter{
    tableFooter = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    [tableFooter setTitle:LocStr(@"more") forState:UIControlStateNormal];
    [tableFooter.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [tableFooter setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
    [tableFooter setBackgroundColor:[UIColor clearColor]];
    [tableFooter addTarget:self action:@selector(startLoadingMore)
          forControlEvents:UIControlEventTouchUpInside];
    moreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [moreIndicator setFrame:CGRectMake(10, 10, 24, 24)];
    [tableFooter insertSubview:moreIndicator atIndex:10];
    [self setTableFooterView:tableFooter];
    [self.tableFooterView setHidden:YES];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, -REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor]];

    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:15.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!isPullEnable) return;
    
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!isPullEnable || isLoading) return;
    
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }else if(scrollView.contentSize.height>scrollView.frame.size.height&&scrollView.contentOffset.y+scrollView.frame.size.height-scrollView.contentSize.height>=REFRESH_HEADER_HEIGHT){
        [self startLoadingMore];
    }
}

- (void)startLoading {
    isLoading = YES;

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    refreshLabel.text = self.textLoading; // 正在刷新
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.contentInset;
    tableContentInset.top = 0.0;
    self.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
    
    // reduce footer
    [moreIndicator stopAnimating];
    [tableFooter setTitle:LocStr(@"more") 
                 forState:UIControlStateNormal];
}

// 加载下一页或更多
- (void)startLoadingMore {
    isLoading = YES;
    [moreIndicator startAnimating];
    [tableFooter setTitle:LocStr(@"refreshing") 
                 forState:UIControlStateNormal];
    [self refreshMore];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished 
                    context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

// 刷新视图
- (void)refresh
{
    // 重写此方法实现下拉刷新事件
    // [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    if([self.refreshDelegate respondsToSelector:@selector(onPullRefresh)])
        [self.refreshDelegate onPullRefresh];
    else
        [self stopLoading];
}

// 底部往上拉
-(void)refreshMore{
    // 重写此方法实现上拉加载更多
    // performSelector:@selector(stopLoadingMore)
    if([self.refreshDelegate respondsToSelector:@selector(onPushLoadingMore)])
        [self.refreshDelegate onPushLoadingMore];
    else
        [self stopLoading];
}

// 隐藏刷新的header和footer
-(void)hideRefresh{
    [refreshHeaderView setHidden:YES];
    [tableFooter setHidden:YES];
}

// 显示刷新的header和footer
-(void)showRefresh{
    [refreshHeaderView setHidden:NO];
    [tableFooter setHidden:NO];
}

-(void)showHeaderView{
    [refreshHeaderView setHidden:NO];
}

@end
