//
//  ViewController.m
//  XZHSocket
//
//  Created by gonghuiiOS on 17/3/23.
//  Copyright © 2017年 熊志华. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *sendMessageTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(strong)  GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)textViewAddText:(NSString *)text {
    //加上换行
    self.textView.text = [_textView.text stringByAppendingFormat:@"%@\n",text];
}
- (IBAction)connectAction:(id)sender {
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    NSError *err = nil;
    if(![_socket connectToHost:_ipTF.text onPort:[_portTF.text intValue] error:&err])
    {
        [self textViewAddText:err.description];
    }else
    {
        NSLog(@"ok");
        [self textViewAddText:@"打开端口"];
    }

    
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self textViewAddText:[NSString stringWithFormat:@"连接到:%@",host]];
    [_socket readDataWithTimeout:-1 tag:0];
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self textViewAddText:[NSString stringWithFormat:@"%@%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
}


- (IBAction)sendMessageAction:(id)sender {
    [_sendMessageTF resignFirstResponder];
    
    [_socket writeData:[_sendMessageTF.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [self textViewAddText:[NSString stringWithFormat:@"发送:%@",_sendMessageTF.text]];
    [_socket readDataWithTimeout:-1 tag:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
