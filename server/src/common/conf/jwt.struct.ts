export class JwtStuct {
    userId: string;
    email: string;
    iat: number = Math.floor(Date.now() / 1000); // issued at (current time in seconds)
    exp: number = Math.floor(Date.now() / 1000) + 60 * 60 * 24; // expires in 1 day
}