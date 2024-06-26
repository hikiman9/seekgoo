package com.seekgu.member.service;

import com.seekgu.member.domain.Member;
import com.seekgu.member.domain.dto.MemberLoginDto;
import com.seekgu.member.domain.dto.MemberSignUpDto;
import com.seekgu.member.exception.AlreadyExistsIdOrNickNameException;
import com.seekgu.member.exception.NotExistUserException;
import com.seekgu.member.exception.NotMatchPasswordException;
import com.seekgu.member.repository.MemberRepository;
import com.seekgu.utils.slack.SlackUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberService {
    private final MemberRepository memberRepository;
    private final SlackUtil slackUtil;

    @Transactional
    public Boolean signUp(MemberSignUpDto memberDto) {
        Member member = Member.builder()
                .memberNickName(memberDto.getMemberNickName())
                .memberName(memberDto.getMemberName())
                .memberId(memberDto.getMemberId())
                .memberPw(memberDto.getMemberPw())
                .memberGender(memberDto.getMemberGender())
                .memberSlackId(slackUtil.getSlackIdByMemberName(memberDto.getMemberName()))
                .build();
        try {
            memberRepository.saveMember(member);
            slackUtil.addMemberToChannel(member.getMemberSlackId());
        } catch (DuplicateKeyException e) {
            throw new AlreadyExistsIdOrNickNameException("이미 존재하는 아이디 또는 닉네임입니다.");
        }

        return Boolean.TRUE;
    }

    public Member login(MemberLoginDto memberLoginDto) {
        Member member = memberRepository.getMemberById(memberLoginDto.getMemberId())
                .orElseThrow(() -> new NotExistUserException("존재하지 않는 회원입니다."));
        if (!isValidPassword(memberLoginDto.getMemberPw(), member.getMemberPw())) {
            throw new NotMatchPasswordException("비밀번호가 일치하지 않습니다.");
        }
        return member;
    }

    private boolean isValidPassword(String inputPassword, String confirmPassword) {
        return confirmPassword.equals(inputPassword);
    }
}
