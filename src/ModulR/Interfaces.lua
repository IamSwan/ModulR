--|| ModulR ||--

--|| Interfaces ||--
export type Service = {
    Name: string,
    Initialize: () -> any,
    Destroy: () -> any,
}

return nil
