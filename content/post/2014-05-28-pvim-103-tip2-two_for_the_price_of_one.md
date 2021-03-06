+++
date  = "2014-05-28T00:00:01+09:00"
title = "일타이피"
tags  = ["vim"]
+++

원문 [Practical Vim - The Vim Way](http://media.pragprog.com/titles/dnvim/vim.pdf)

*A*명령은 두 동작을 *$a* 하나의 키입력으로 합친 것이라고 말할 수 있습니다. 이처럼 동작하는 명령은 이것 하나만 있는 것이 아닙니다. Vim에는 두 개 이상의 명령을 압축한 복합명령들이 있습니다. 아래 표는 그 예를 몇 가지 보여줍니다. 혹시 공통점이 보이나요?

| 복합명령 | 동등한 명령  |
|-------|-----------|
| C     | c$        |
| s     | cl        |
| S     | ^C        |
| I     | ^i        |
| A     | $a        |
| o     | A\<CR\>   |
| O     | ko        |

*ko*( 혹은 더 나쁘게 *k$a\<CR\>*)를 입력한다면, 그만 사용하고, 무엇을 하고 있는지 생각을 해보면 *O*명령과 동일하다는 것을 알게 됩니다.

이 명령들의 공통점은 전부는 노말모드에서 입력모드로 전환을 합니다. 이 공통점이 점명령에 어떤 영향을 주는지 한번 생각해보세요. ^^ 피스~