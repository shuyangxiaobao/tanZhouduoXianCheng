//
//  ViewController.m
//  多线程Pthread Nsthread GCD NSOperation
//
//  Created by 戈强宝 on 2018/5/30.
//  Copyright © 2018年 戈强宝. All rights reserved.
//

#import "ViewController.h"

//  并发编程!!Pthread NSThread   GCD NSOperation 并发技术!

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多线程";
    UITableView *table = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    table.backgroundColor = [UIColor whiteColor];
    table.dataSource = self;
    table.delegate = self;
    self.tableView = table;
    [self.view addSubview:table];
    self.data = [NSMutableArray arrayWithCapacity:4];
    Model *m0 = [[Model alloc]init];
    m0.className = @"PthreadViewController";
    m0.myDescription = @"pthread";
    
    Model *m1 = [[Model alloc]init];
    m1.className = @"NSThreadViewController";
    m1.myDescription = @"NSThread";
    
    
    Model *m2 = [[Model alloc]init];
    m2.className = @"NSOperationViewController";
    m2.myDescription = @"NSOperation";
    
    
    Model *m3 = [[Model alloc]init];
    m3.className = @"GCDViewController";
    m3.myDescription = @"GCD";
    
    Model *m4 = [[Model alloc]init];
    m4.className = @"RunLoopViewController";
    m4.myDescription = @"RunLoop";
    
    
    
    
    
    
    [self.data addObject:m0];
    [self.data addObject:m1];
    [self.data addObject:m2];
    [self.data addObject:m3];
    [self.data addObject:m4];

    // Do any additional setup after loading the view, typically from a nib.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *signCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:signCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:signCell];
    }
    
    Model *m = [self.data objectAtIndex:indexPath.row];
    
    cell.textLabel.text = m.myDescription;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *m = [self.data objectAtIndex:indexPath.row];
    Class classNmae = NSClassFromString(m.className);
    UIViewController *vc = [[classNmae alloc]init];
    vc.title = m.className;
    [self.navigationController pushViewController:vc animated:YES];

}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
