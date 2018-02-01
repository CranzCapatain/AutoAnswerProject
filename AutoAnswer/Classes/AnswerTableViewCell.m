//
//  AnswerTableViewCell.m
//  AutoAnswer
//
//  Created by 金峰 on 2018/1/17.
//  Copyright © 2018年 金峰. All rights reserved.
//

#import "AnswerTableViewCell.h"

@interface AnswerTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *optionLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation AnswerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.optionLabel = [[UILabel alloc] init];
    self.optionLabel.font = [UIFont systemFontOfSize:14];
    self.optionLabel.textColor = [UIColor lightGrayColor];
    self.optionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.optionLabel];
    
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.font = [UIFont boldSystemFontOfSize:15];
    self.resultLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:self.resultLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@20);
        make.right.lessThanOrEqualTo(@(-20));
    }];

    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(@20);
    }];

    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.optionLabel.mas_bottom).offset(15);
        make.left.equalTo(@20);
        make.bottom.equalTo(@(-15));
    }];
}

- (void)setTopic:(Topic *)topic {
    _topic = topic;
    
    self.titleLabel.text = topic.title;
    NSMutableString *options = [NSMutableString string];
    for (int i = 0; i < topic.answers.count; ++i) {
        if (i == 0) {
            [options appendString:topic.answers[i]];
        } else {
            [options appendFormat:@"\n%@",topic.answers[i]];
        }
    }
    self.optionLabel.text = [options copy];
    self.resultLabel.text = [NSString stringWithFormat:@"推荐答案：%@",topic.result];
}


@end
