# 비공식듀오

레드크리스탈 중매사가 엄선한 프로필

## 1. Supabase

1. Supabase Dashboard → SQL Editor → New query
2. `supabase/schema.sql` 내용을 붙여 넣고 Run
3. Project Settings → API Keys에서 **secret/service_role** 키 확인 (브라우저·GitHub에 공개 금지)
4. Project URL 확인

## 2. GitHub

이 폴더의 **내용물 전체** (`api/`, `public/`, `supabase/`, `package.json`, `vercel.json` 등)를 생성한 **Private** 저장소 루트에 업로드합니다. `.env` 파일은 절대 업로드하지 않습니다.

## 3. Vercel

1. Add New → Project → Import Git Repository → 해당 저장소 선택
2. Framework Preset: Other, Root Directory: `./`
3. Settings → Environment Variables (Production/Preview/Development 필요 범위에 등록)
   - `SUPABASE_URL`: Supabase 프로젝트 URL
   - `SUPABASE_SERVICE_ROLE_KEY`: Supabase 서버 전용 secret/service_role 키
   - `SESSION_SECRET`: 임의의 32자 이상 비밀 문자열 (권장 64자 이상)
   - `OWNER_USERNAME`: `owner`
   - `OWNER_PASSWORD`: 처음 사용할 최고 관리자 비밀번호 (12자 이상, 강력하게 설정)
   - `PUBLIC_BASE_URL`: 배포 후 실제 URL (예: `https://bigongsik-duo.vercel.app`, 마지막 `/` 없이)
4. Deploy. URL 확정 후 `PUBLIC_BASE_URL` 설정을 실제 주소로 업데이트하고 Redeploy.
5. 웹사이트 접속 → 최고 관리자 계정 `owner`와 `OWNER_PASSWORD`로 로그인. 첫 로그인 성공 시 DB에 최고 관리자 계정이 생성됩니다.

**중요:** 첫 로그인 전에 SQL 실행이 끝나야 합니다. 기존 v2의 `data.json`은 자동 이관되지 않습니다. 기존 프로필이 있다면 새 관리자 화면에서 다시 등록해야 합니다.

## 사용법

- 관리자 로그인 → 프로필 관리 → 프로필 등록. 본인의 공개 동의를 받은 성인 프로필만 등록
- 초대 링크 관리 → 공개할 프로필 체크 → 유효기간 설정 → 링크 생성 → 링크를 즉시 복사 (원본 링크는 재표시되지 않음)
- 최고 관리자 로그인 → 관리자 관리 → 일반 관리자 추가, 비밀번호 재설정, 권한 해제
- 초대받은 사람은 `/?invite=...` 링크로 지정된 프로필만 열람

## 보안 및 운영 유의사항

- 브라우저에서 Supabase에 직접 연결하지 않습니다. 모든 데이터는 서버 함수에서 service_role로 접근하고 권한을 확인합니다.
- 모든 테이블 RLS 활성화, anon/authenticated 권한 제거. 사진은 private bucket에 저장하고 5분 만료 서명 URL을 발급합니다.
- 초대 토큰은 해시만 저장합니다. 링크 소유자는 지정된 프로필을 볼 수 있으므로 전달받은 링크가 재공유되면 접근이 가능합니다.
- 관리자 로그인 시도는 DB 기반으로 15분에 IP당 15회 제한됩니다. 장기간 운영 시 로그인 시도 로그 정리 작업을 추가하세요.
- 관리자의 권한 해제/비밀번호 변경 시 기존 세션 무효화. 세션 유효기간 8시간.
- 초대 링크를 폐기하더라도 이미 발급된 사진 서명 URL은 최대 5분간 유효할 수 있습니다.
- 공개 동의 철회 시 프로필을 삭제하고 이미 공유된 사진이나 스크린샷은 회수할 수 없음을 안내하세요.
- 실서비스 운영 전 개인정보 처리방침, 동의·삭제 절차, 백업, 모니터링, 보안 테스트를 추가로 검토하세요.
- `OWNER_PASSWORD`는 초기 최고 관리자 생성에만 사용합니다. 계정 생성 후 변경하려면 별도의 관리자 비밀번호 변경 기능을 구현하거나 DB에서 안전하게 갱신해야 합니다.

## 로컬 실행 (선택)

`npm install`, `npx vercel dev` (Vercel CLI 설치/로그인 및 환경변수 연결 필요)
